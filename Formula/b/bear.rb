class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/refs/tags/4.0.2.tar.gz"
  sha256 "e0b54ccd7a2442209fa4313a7e715cc59af83f93b2d7bf2d92633b6e4c9a7edc"
  license "GPL-3.0-or-later"
  head "https://github.com/rizsotto/Bear.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af0bd82b5fb44403ba41bde1ce77f2b8206721782055a0555f367770331d958d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9023fafe60e272fc8cfc682aeaa53cd44af7240ed77e7ab8d49d902fc984cca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad81c802f4891cf9721ea740b303939bb2cdb2e1db643d06c1e9fdff204bcf89"
    sha256 cellar: :any_skip_relocation, sonoma:        "10bdd1aebc45edb0e77585fc9212f5b65865adf091e4ff410bf378346b6f2b13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d79ece17332eafd96e9ebc1c5e71e0877672564d05c04235772654659be82198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b375206197f5dd0857545e8a2895fcd31a53e88a0ce98b029d180bf6900925f"
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
