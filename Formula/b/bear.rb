class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.0.3.tar.gz"
  sha256 "99a03b33cb762391d7122ca05ef41f2029cbe9bc43f23e7068dee88637c5b269"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af05b672bfb451183a9607e0205e1fcc1e54bfaaacd77a738ae05445fcb74a7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a2bda509c5f491887610b72b4f9d88325c33a1931b8aaf942ec47eae0db04bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ed259cb6d11f55fb4845eebbc0133cd3d81e46ee44ffa5b2b9f67f5c8aa6e98"
    sha256 cellar: :any_skip_relocation, sonoma:        "f886b32ca8a37bee9f6515d89cd78665df8890f7d66ccbb08bbf80fbf9054039"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2704f16c75d0699bb4381b281e8137b4247f795ef615e8b53c8e937d12a623e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f5da412d4e41abf601d727305bfbf6a19331aa5285456be64e76134a574816c"
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
