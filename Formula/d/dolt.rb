class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v1.12.0.tar.gz"
  sha256 "fff38688f90c6e7d9bfd337df1d8045921f1c3c5129155804f421e5a2cd95dbe"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bee25887e9e271e0e80494088eaa9af1077951c3e35f7721f2d4e4bd46903e3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5d69d44d743bbb62a1598672889332352231e21b1c7deefa090d3a593e85b85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ead599d01a23e2f8c5b1eb9d214b37a68a3155128f7ad8457301480a8cf2926c"
    sha256 cellar: :any_skip_relocation, ventura:        "77c26e6dd989a189b6f2d8d69b8a263774e5b5edeec9e10a6e04cf9f759f90d3"
    sha256 cellar: :any_skip_relocation, monterey:       "9b309fc028efac7600eda56043880428871e9c9552389439b1c528ef0dfd39b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f7c212a349aa3d6cb78ff627366e0ce6e628f499ee5460834bf4a8d45bafba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "590f88b7650a326b5a1d529a1fb79c4c4b52288b18d1d97b8edeb700ee06f06b"
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
