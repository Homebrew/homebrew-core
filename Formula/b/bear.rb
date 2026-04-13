class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.1.1.tar.gz"
  sha256 "58665614e59f3b7f7127e6a6fe4c94ddc64b81e80a4c160ecbd7e44b9171308f"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "303b147afe71ec87067b48a1ac5f4e34add746abe5f60061c6c3f5066a13414e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c64e2d1bc0fe311705b1f2edc96500eec2dda1d8f4518e0fb475200ed1764517"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6104e5b2d2afb61371e607b70466fc3f3e2d72035b63449676bf072e1cacb7bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "43fd5a936bba402659fb5a021d3ad9907a76e31d160a2034b47508a46755bba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "246c58d533db6b18c339211ffdb8bdfff029b1777ca8db73ba012429d6e83894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5512f8683b3348cc16d17c235b47b860ea29eb3e6df09c6e3dcede312045a5d2"
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
