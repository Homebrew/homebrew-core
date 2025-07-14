class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https://inko-lang.org/"
  url "https://releases.inko-lang.org/0.18.1.tar.gz"
  sha256 "498d7062ab2689850f56f5a85f5331115a8d1bee147e87c0fdfe97894bc94d80"
  license "MPL-2.0"
  head "https://github.com/inko-lang/inko.git", branch: "main"

  # The upstream website doesn't provide easily accessible version information
  # or link to release tarballs, so we check the release manifest file that
  # the Inko version manager (`ivm`) uses.
  livecheck do
    url "https://releases.inko-lang.org/manifest.txt"
    regex(/^v?(\d+(?:\.\d+)+)$/im)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "ee26a0c11c1c527151fde51739a7f4fe5ac5f721805deb98e1a5f2bd3024d038"
    sha256 cellar: :any,                 arm64_sonoma:  "44fc95eba234a04e7cfe132a17874892a86fdcf0b198a07de3ca5807fdead3be"
    sha256 cellar: :any,                 arm64_ventura: "e61d4dd6bacfdb7d01a885493de960998271cf10f6bf4931a2deecef27a59eec"
    sha256 cellar: :any,                 sonoma:        "487151f34bc632c5d5618cb65d06efd23afd8f8dac3becf13f2b2597e18aa4e5"
    sha256 cellar: :any,                 ventura:       "f4b935a853326a2422c5f2bb826c765d9cfa27dd32ebf8005e1d1f7bdbdd58f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "578ff3eacb96844be7e983fd7c8bf8c7481138ea12425cbdd9cf2c95e317060a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7af46ba20d2d34d8d5ec23574d97caa98a50278eca21fd9e1573856cf58ee24f"
  end

  depends_on "rust" => :build
  depends_on "llvm@17" # see https://github.com/inko-lang/inko/blob/4738b81dbec1f50dadeec3608dde855583f80dda/ci/mac.sh#L5

  uses_from_macos "libffi", since: :catalina

  def install
    # Avoid statically linking to LLVM
    inreplace "compiler/Cargo.toml", 'features = ["prefer-static"]', 'features = ["force-dynamic"]'

    system "make", "build", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"hello.inko").write <<~INKO
      import std.stdio (Stdout)

      class async Main {
        fn async main {
          Stdout.new.print('Hello, world!')
        }
      }
    INKO
    assert_equal "Hello, world!\n", shell_output("#{bin}/inko run hello.inko")
  end
end
