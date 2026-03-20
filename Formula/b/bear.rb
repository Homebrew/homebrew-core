class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.0.4.tar.gz"
  sha256 "373007f2d7b322d5e1d3dd4c4759b181f0e9b045151f2f5c629537341b9d2167"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dff39fe2a75cdaa8f208bcb88add9374cfeb94099f9b1e4a9277c8aa462a9e60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "831aba7478d6c4d08a82f624e6fb03d564282223fd9703ca0e9248931781d836"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "953e42741dc3bdeea94afae5469993a9f9d817284a986da7b41187e3f81effdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "424136238384167d6140333113688d865f4f1d1d0a7c475c2602cef2b333b57d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2acf72c5b7ecfbacf3173f7ccc7d54da6f3c36761ece9dc611aa2ccd419bad54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7694330edf9b1182a4111328927632191bf892f537d23a9d053819c991a4093d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :test
  end

  def install
    # Patch build.rs to use Homebrew's libexec path instead of /usr/local/libexec
    inreplace "bear/build.rs" do |s|
      s.gsub! "/usr/local/libexec/bear/$LIB", "#{libexec}/$LIB"
      s.gsub! "/usr/local/libexec/bear", libexec/"bin"
    end

    system "cargo", "install", *std_cargo_args(path: "intercept-wrapper", root: libexec)
    system "cargo", "install", *std_cargo_args(path: "bear")

    if OS.linux?
      ENV.append_to_rustflags "-C link-arg=-fuse-ld=lld"
      system "cargo", "build", "--release", "--lib", "--manifest-path=intercept-preload/Cargo.toml"
      (libexec/"lib").install "target/release/libexec.so"
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
