class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.4.0/apache-opennlp-2.4.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.4.0/apache-opennlp-2.4.0-bin.tar.gz"
  sha256 "dd0cee5542e128130333e99bbea649f5fd5eb6f264fd4e1c6403f0427077c2ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "945990553a999f9bab2565debc3718311b21bcf0f430e69677c47b5026c595a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "945990553a999f9bab2565debc3718311b21bcf0f430e69677c47b5026c595a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "945990553a999f9bab2565debc3718311b21bcf0f430e69677c47b5026c595a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "945990553a999f9bab2565debc3718311b21bcf0f430e69677c47b5026c595a2"
    sha256 cellar: :any_skip_relocation, ventura:        "945990553a999f9bab2565debc3718311b21bcf0f430e69677c47b5026c595a2"
    sha256 cellar: :any_skip_relocation, monterey:       "945990553a999f9bab2565debc3718311b21bcf0f430e69677c47b5026c595a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38eda0c61729d3c02194953d57e397afcb5627e3e31ccff4af3522aad07f4bcc"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"opennlp").write_env_script libexec/"bin/opennlp", JAVA_HOME:    Formula["openjdk"].opt_prefix,
                                                            OPENNLP_HOME: libexec
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends").lines.first.chomp
  end
end
