class Pijul < Formula
  desc "Patch-based distributed version control system"
  homepage "https://pijul.org"
  url "https://pijul.org/releases/pijul-0.12.0.tar.gz"
  sha256 "987820fa2a6fe92a9f516f5e9b41ad59a597973e72cb0c7a44ca0f38e741a7e6"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "c5cc98c1979e4e782685774e3e5ff449f6968123f6e79ff68ecf8c4cf8656266" => :catalina
    sha256 "73bf314aa865452f0f7104430a64be1922f31553c2b41e36e8fc0ba8657ca7b2" => :mojave
    sha256 "b5dbbecb1823507658c535c4d60d8374a0924169a1994bf68d0210a62f42ea17" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"
  depends_on "nettle"
  depends_on "openssl@1.1"

  def install
    # Applies a bugfix (0.20.7 -> 0.20.8) update to a dependency to fix compile.
    # Remove with the next version.
    system "cargo", "update", "-p", "thrussh", "--precise", "0.20.8"

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    cd "pijul" do
      system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    end
  end

  test do
    system bin/"pijul", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system bin/"pijul", "add", "haunted", "house"
    system bin/"pijul", "record", "--all",
                                  "--message='Initial Patch'",
                                  "--author='Foo Bar <baz@example.com>'"
    assert_equal "haunted\nhouse\n", shell_output("#{bin}/pijul ls")
  end
end
