class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.6.2.tar.gz"
  sha256 "c0a3e612b41f441081098e3f3e1716fc709421f3d17654a9f0303f420fdbc1ee"

  bottle do
    cellar :any
    sha256 "0764047a3f1f74e5a1e326d22877c3d5405c7dc290cf1cd8f67b73ab99d647a0" => :catalina
    sha256 "18c66958772ae8a83f089edf9b5a7c7686b5a568fb6239d0bf82b2b009e192a6" => :mojave
    sha256 "f3da39b2fc89a234bb15871020bdb510de266e54aa6df2d845dc6c6fed7a9d6a" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
