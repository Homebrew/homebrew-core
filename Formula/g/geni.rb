class Geni < Formula
  desc "Standalone database migration tool"
  homepage "https://github.com/emilpriver/geni"
  url "https://github.com/emilpriver/geni/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "e83d2db6ded980c52de2899a8e7e222e8c16543e3bd29758a7c50676804f2217"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4a0be3655dcabe47521bfb62a5d54786b0b7868b1e695fa066a10469d113898"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ff878e30e3f94acbacfe6dbe371b22b56ab8e3c853f050cde85d15b347ff5c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36ba5e637e39fb5a34e2c51c2c2132e68377c433cdb02d9c536aa86e9c44985a"
    sha256 cellar: :any_skip_relocation, sonoma:        "457bed36a15844e8d0ceb1e96090b0b3bf8d66c82c21a2c13b2a16e49a0d0378"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c9861180de0e873cc4d7e1345a3c14d86e3afb3bd285a6d01eb90afa2e3e489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39f249e8eaf44e74847042c646acaaf8f9fff7d027150f8353149668cdf98582"
  end

  depends_on "rust" => :build

  def install
    # Workaround to build `aegis v0.9.3` for arm64 linux without -march `sha3`
    ENV.append_to_cflags "-march=native" if OS.linux? && Hardware::CPU.arm?
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["DATABASE_URL"] = "sqlite3://test.sqlite"
    system bin/"geni", "create"
    assert_path_exists testpath/"test.sqlite", "failed to create test.sqlite"
    assert_match version.to_s, shell_output("#{bin}/geni --version")
  end
end
