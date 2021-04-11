class CargoWatch < Formula
  desc "Watches over your Cargo project's source"
  homepage "https://github.com/passcod/cargo-watch"
  url "https://github.com/passcod/cargo-watch/archive/v7.7.0.tar.gz"
  sha256 "63099570b5716125e911ca74d1e4b2e3cf07d432d8af5b9da30cb43d0f0723f4"
  license "CC0-1.0"
  head "https://github.com/passcod/cargo-watch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "28e2f5f35ef1c06dcad40aac42d27b264930ccde4dc6ef9ce07dc3c3476cd8d9"
    sha256 cellar: :any_skip_relocation, big_sur:       "6eae6f5fea5a7976c8557e6013d04c210d201c9745a240eee77b3c77a4496d94"
    sha256 cellar: :any_skip_relocation, catalina:      "957bbaec8399a7b996a0f1494b2e0faa4766545d297181bb1b5a8ba29bfca8cb"
    sha256 cellar: :any_skip_relocation, mojave:        "4c52cc87634af16d006b4a9528db2bd3c4ae1849700dcb0dca313a97b7ac5e3d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/cargo-watch -x build 2>&1", 1)
    assert_match "error: Not a Cargo project, aborting.", output

    assert_equal "cargo-watch #{version}", shell_output("#{bin}/cargo-watch --version").strip
  end
end
