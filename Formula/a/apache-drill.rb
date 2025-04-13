class ApacheDrill < Formula
  desc "Schema-free SQL Query Engine for Hadoop, NoSQL and Cloud Storage"
  homepage "https://drill.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=drill/1.21.2/apache-drill-1.21.2.tar.gz"
  mirror "https://dlcdn.apache.org/drill/1.21.2/apache-drill-1.21.2.tar.gz"
  sha256 "77e2e7438f1b4605409828eaa86690f1e84b038465778a04585bd8fb21d68e3b"
  license "Apache-2.0"

  livecheck do
    url "https://drill.apache.org/download/"
    regex(/href=.*?apache-drill[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "1fdc04dff9efe56387a375149ae2d30249bf790dd6a821f3410439b92bc51dd0"
  end

  depends_on "openjdk@21"

  def install
    rm(Dir["bin/*.bat"])
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("21"))
    rm(Dir["#{bin}/*.txt"])
  end

  test do
    ENV["DRILL_LOG_DIR"] = ENV["TMP"]
    output = pipe_output("#{bin}/sqlline -u jdbc:drill:zk=local 2>&1", "!tables", 0)
    refute_match "Exception:", output

    (testpath/"query.sql").write <<~SQL
      SELECT employee_id, last_name, birth_date FROM cp.`employee.json` LIMIT 3;
      SELECT * FROM dfs.`#{libexec}/sample-data/region.parquet`;
    SQL
    assert_match <<~EOS, shell_output("#{bin}/drill-embedded --run=#{testpath}/query.sql")
      +-------------+-----------+------------+
      | employee_id | last_name | birth_date |
      +-------------+-----------+------------+
      | 1           | Nowmer    | 1961-08-26 |
      | 2           | Whelply   | 1915-07-03 |
      | 4           | Spence    | 1969-06-20 |
      +-------------+-----------+------------+
      +-------------+-------------+----------------------+
      | R_REGIONKEY |   R_NAME    |      R_COMMENT       |
      +-------------+-------------+----------------------+
      | 0           | AFRICA      | lar deposits. blithe |
      | 1           | AMERICA     | hs use ironic, even  |
      | 2           | ASIA        | ges. thinly even pin |
      | 3           | EUROPE      | ly final courts cajo |
      | 4           | MIDDLE EAST | uickly special accou |
      +-------------+-------------+----------------------+
    EOS
  end
end
