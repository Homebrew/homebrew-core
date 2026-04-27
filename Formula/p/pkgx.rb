class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https://pkgx.sh"
  url "https://github.com/pkgxdev/pkgx/archive/refs/tags/v2.10.3.tar.gz"
  sha256 "6df90a10139006a9ab36102b1e4394a2a6741120b197d1e84da7ec3b9f211b95"
  license "Apache-2.0"
  head "https://github.com/pkgxdev/pkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f1ad62d8baef97a5719648f8474d104c766b5a302dd851d2c60fcd4a617d006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d1675caac03cbe6d7440398dc439cf5c018909443180be43a982ddeea9ae689"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c31fa1c2ae16d736a323c053d6efb2d1dba5cb8f233396ffe9113580442b5fdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "0788ae2f351d725cb1b0d4bb38d4860c6869e4155d6aa97440fc5e5873ec92a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dae000456643ada790f9bbd0330985cad0292f29f5eb45eeafde486bbf32ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec9e6613fb9d4197d862897c369189597579a1845358f57a0728a98d83ad6601"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"main.go").write <<~GO
      package main

      func main() {
        println("Hello world")
      }
    GO
    assert_match "1.23", shell_output("#{bin}/pkgx go@1.23 version")
    assert_match "Hello world", shell_output("#{bin}/pkgx go@1.23 run main.go 2>&1")
  end
end
