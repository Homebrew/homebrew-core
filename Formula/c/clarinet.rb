class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "6080cc1f634204cc8f329c38f4445a67f663cbc8c05124ccb16bea20fe8ac8cc"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a691642750c58f7f6ed406f1087bbea427806717f5806b40c8b6543e8c4f087"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d5a792260539c95630609afb057ad013d3348e80aa43ec9329367ff0531cba7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc5dff3ec361ac4485d951c7d3cb9f206ee4fa4763802d939cfe9daebca80f24"
    sha256 cellar: :any_skip_relocation, sonoma:         "55b630eaeb069cb644128028d237de54a963073f2b4ca76e8a9d0bb3737170ff"
    sha256 cellar: :any_skip_relocation, ventura:        "b44b29da04f08905d55fb4e86da24e798f23167f800a876d434dcb57a0eb14ed"
    sha256 cellar: :any_skip_relocation, monterey:       "104a5286aa6d464b10eb77c6b497910a9d2697433c260ece334800dafcc8a4bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b8e5fb63dcd80f7070bac6afeac09abf37f994fea016018ebe78c39b4f8d4c8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
