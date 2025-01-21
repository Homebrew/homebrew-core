class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https://pkgx.sh"
  url "https://github.com/pkgxdev/pkgx/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "853f61de9b5ff7507346e47f9d6b7de361253eff95911641838230e380fca9e1"
  license "Apache-2.0"
  head "https://github.com/pkgxdev/pkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f77987ce353af185be7d7c4d1a13e6c38a62bf75046284e1e93c0283a9288d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e81d0f1eea7410e0b93fdd3df9bb0050b1b0ea5bfbf547687d3f6ae99c99996"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2a3e62201da98b970822c4f7dbbe7a6b674a9f49ae752c1731855ecc2a4e515"
    sha256 cellar: :any_skip_relocation, sonoma:        "39c01540f7b68c7b44ee2f9118f07081aa5f742be89133b954f1cf2b4f995fd9"
    sha256 cellar: :any_skip_relocation, ventura:       "df20febf873562fedbe09cd487e8ad3aaf80059dbe5f065b2919fb4a53daf0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff24611811bf0e7cba81e298e5d2e060447a09fad7e1b631bf794fdd98b073ce"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
