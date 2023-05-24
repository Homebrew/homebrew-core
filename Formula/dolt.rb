class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.1.2.tar.gz"
  sha256 "6e815b6a77278287fc75b3a99ec4726d08e67b9f36781d0518ffb0da6686d9a9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46551d4fd4566163541b79d7719ed38d0fdabc3a3e35dddcfba49a70b5b249f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46551d4fd4566163541b79d7719ed38d0fdabc3a3e35dddcfba49a70b5b249f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46551d4fd4566163541b79d7719ed38d0fdabc3a3e35dddcfba49a70b5b249f9"
    sha256 cellar: :any_skip_relocation, ventura:        "0020f46274d6ba5fdbd1dcc8c5efb9067d0f9908367242471ef6c52392b3137e"
    sha256 cellar: :any_skip_relocation, monterey:       "0020f46274d6ba5fdbd1dcc8c5efb9067d0f9908367242471ef6c52392b3137e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0020f46274d6ba5fdbd1dcc8c5efb9067d0f9908367242471ef6c52392b3137e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94061e8d00bc79841b7758978f98f4d61b2734e0bc101d270a0678d3cae5fddc"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
