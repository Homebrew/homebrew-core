class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.1.2.tar.gz"
  sha256 "34e20693d9f3f6820bf330d5dc426eeafb33092c24208f25954d401a92083673"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "360d8afdbbabb9ce4bf252f98492770ecc35881fe9b8b2d5c0da1b80ae3045ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c1886863af5933ab1d9c11838e3bf4fadffd24625316be805521d5461dd8873"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0c8421b477a0b47c86d419643b83eec07d3cdb013ca0f53ac6cf222ddd5956d"
    sha256 cellar: :any_skip_relocation, sonoma:        "597f5e3140145992d533c359411514bf68b2df5b52b8387be6a0b96eeaf08802"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "218194a82804ed5d96945599baec733ff3fb21812b36898fea14eb9b5ec03874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3da0d1eb47b6903a219b8eb28debb16e1380da5df1d81d3d4a3c769008a8e434"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :test
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "bear")

    if OS.linux?
      ENV.append_to_rustflags "-C link-arg=-fuse-ld=lld"
      system "cargo", "build", "--release", "--lib", "--manifest-path=intercept-preload/Cargo.toml"
      (libexec/"lib").install "target/release/libexec.so"
    end

    with_env(PREFIX: prefix) do
      system "scripts/install.sh"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    C
    system bin/"bear", "--", "clang", "test.c"
    assert_path_exists testpath/"compile_commands.json"
  end
end
