class Pkgx < Formula
  desc "Standalone binary that can run anything"
  homepage "https://pkgx.sh"
  url "https://github.com/pkgxdev/pkgx/archive/refs/tags/v2.7.tar.gz"
  sha256 "479897abc6d51df25bda10b98ab6efef8424cb14bfd3003148d55216e6ca353b"
  license "Apache-2.0"
  head "https://github.com/pkgxdev/pkgx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf31f5eaabb8fd15f2bb5f8f73b55e4133813cc06d761fc3690a2044c8422e6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d54923e20f0940729bec3cda7d4d597ea3b5535776e8aaaffa76927a5d83fdf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d02236c3096e6cb1755fe79a4f35002f20afd3ec72debc05c5e23c85e287c81f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c74465ddc16dded699648b040ec1d7a7d45bd1d0ed5f3fb64c2155379f1d5372"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b4a08f77e540968ad06d9910b56f2aeaf3e95a8e9eb62a71f6ca5047f7eea5d"
    sha256 cellar: :any_skip_relocation, ventura:       "a8931040aed065d0d8374df553904f6da327fdc3b6b22b0516893de41447bef6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2bf05af625f05d00d025bf90f48d195a3ad1e78f514cb000827260a18aeed11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdeed2e0e4c6d5943a8edacddbe544ac18eb1a6fd7024d7d476cdf5342ae1afb"
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
