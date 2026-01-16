class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.0.1.tar.gz"
  sha256 "64bcd65a333c6060d929c62b461edbd172a7256e42aae6d327982a0ce643a20c"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "985451c0b4bdd660ec49e84adfdfbee8b2c289ad19526c3dc9670b8f8710ad11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff909dc7b0a3b7759ea28768b6cea860067fa5dc8673cdc3f79c7aab074e0df5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0345cb43d79ea9abf60c3b17fe8a21211a45774fc2b338c4d6e8d6dbb3af3608"
    sha256 cellar: :any_skip_relocation, sonoma:        "97383007dd5e5b74c2565fdddd97ce6a44250e047bf6c7431a864e97c408745c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "130e714bb5840ab7319c31dbc8ec353f60a4a5260d390f8d0e662fc5530f3f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b2bad346cb4099a16569c0641ef5fc67df9ad5d089205cfb39264c0a04abbc6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
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
