class Dexter < Formula
  desc "Automatic indexer for Postgres"
  homepage "https://github.com/ankane/dexter"
  url "https://github.com/ankane/dexter/archive/v0.5.1.tar.gz"
  sha256 "280403858ea209b41910f487f737fd602b41c60cc6cd3e5cf54ed5db9330b321"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "92cb0fbac4487c140ca08f6f455a59c08244fc1a983c7601231a350a5a57e14e"
    sha256 cellar: :any,                 arm64_ventura:  "0d0819a25037801276345d56e2c65efd77599cfbc5753c2b6050b1a5678778dc"
    sha256 cellar: :any,                 arm64_monterey: "e3a0878eda19b97048653255f5eabffec541c6404e9ab052dc4c4726da64e2d8"
    sha256 cellar: :any,                 arm64_big_sur:  "c87db9cbd96d7a827e91ef098254667d6421f8e000a3b073ec9f709a65537f57"
    sha256 cellar: :any,                 sonoma:         "b450fd6b57aaf98dc7dee198a2a88e08b064965fcab1581c4b181ada1fa325c7"
    sha256 cellar: :any,                 ventura:        "0b5646a0960610fa1374292d65027cf43b345c247623cb9df7120b4683536aa2"
    sha256 cellar: :any,                 monterey:       "d1a8e777427a998b6001bed942da698b3000055d8d654bfb49d2cc025f6adb22"
    sha256 cellar: :any,                 big_sur:        "a3fea06cec0f5ae107c9e244a03f63bd4cf09a503620aaf5f68e9dc38d0d0c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fc114dc62a681eb4c133d60c2ff6604c9f3fa59a4072ae7a6b295d6a158b5f1"
  end

  depends_on "postgresql@15" => :test
  depends_on "libpq"
  depends_on "ruby"

  resource "google-protobuf" do
    url "https://rubygems.org/gems/google-protobuf-3.23.2.gem"
    sha256 "499ac76d22e86a050e3743a4ca332c84eb5a501a29079849f15c6dfecdbcd00f"
  end

  resource "pg" do
    url "https://rubygems.org/gems/pg-1.5.3.gem"
    sha256 "6b9ee5e2d5aee975588232c41f8203e766157cf71dba54ee85b343a45ced9bfd"
  end

  resource "pg_query" do
    url "https://rubygems.org/gems/pg_query-4.2.1.gem"
    sha256 "b04820a9d1c0c1608e3240b7d84baabbee1b95a7302f29fdd0f00e901c604833"
  end

  resource "slop" do
    url "https://rubygems.org/gems/slop-4.10.1.gem"
    sha256 "844322b5ffcf17ed4815fdb173b04a20dd82b4fd93e3744c88c8fafea696d9c7"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "gem", "build", "pgdexter.gemspec"
    system "gem", "install", "--ignore-dependencies", "pgdexter-#{version}.gem"

    bin.install libexec/"bin/dexter"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@15"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      output = shell_output("#{bin}/dexter -d postgres -p #{port} -s SELECT 1 2>&1", 1)
      assert_match "Install HypoPG", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
