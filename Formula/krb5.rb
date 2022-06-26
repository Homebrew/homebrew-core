class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.20/krb5-1.20.tar.gz"
  sha256 "7e022bdd3c851830173f9faaa006a230a0e0fdad4c953e85bff4bf0da036e12f"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_monterey: "ad559a03cc8661b668d51d71d3dc44b84eb853b35415aa0cc0a75fefc15bfeb6"
    sha256 arm64_big_sur:  "8f6f51da9bf8693e7976954aee19d444d483070cf33ad6453219f032b1bcd1ec"
    sha256 monterey:       "99e8f567b0f70cc50309acf37f5e4b792dcd8fbd034e869e58e3e0f38ad73ec9"
    sha256 big_sur:        "8e6be25060a0223ec6e8935e575d4b07ff9235f3b5c7e273bd8c79b401a0abfc"
    sha256 catalina:       "6e8e5a00dff92c729f276ba9d287689e0222a4293f7c8c502ee2781c2a1d4a2e"
    sha256 x86_64_linux:   "17c3f6518fc7f836cd1bcc8ae0f2d8a8cc9d8ca063fa78d2faaf67158bf3318d"
  end

  keg_only :provided_by_macos

  depends_on "openssl@1.1"

  uses_from_macos "bison"

  on_linux do
    depends_on "gettext"
  end

  def install
    cd "src" do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}",
                            "--without-system-verto",
                            "--without-keyutils"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/krb5-config", "--version"
    assert_match include.to_s,
      shell_output("#{bin}/krb5-config --cflags")
  end
end
