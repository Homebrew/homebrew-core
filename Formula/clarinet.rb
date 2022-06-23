class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v0.32.0",
      revision: "30fa422f58f108e2e13e10e893117706d4cc1c1a"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbf9ee8e585d8e8407810e2e5ebebdc45c1fa0166e8dbf1d4ef58a06028fc74b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d1565f1b3f4e1a20952cac4c128e880ff84137ad83f714918b13a5688262efb"
    sha256 cellar: :any_skip_relocation, monterey:       "23aaa31762667e5af1cb8efb376a20cfcf1e26d520565475f974581db16ef5c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "319384a71d8cb65fa21180f12eaf1980480b021764bf00aefdc1a32a1aaf88a3"
    sha256 cellar: :any_skip_relocation, catalina:       "3cffa10eab9865a51ae1548158a7a8e302e0d97ff617f414bae96452b3dc7245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27db4b124dedc2f0d787711ac1bafc9484c4e75c503fd207a6e0f444f9e54620"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
