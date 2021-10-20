class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.19/krb5-1.19.2.tar.gz"
  sha256 "10453fee4e3a8f8ce6129059e5c050b8a65dab1c257df68b99b3112eaa0cdf6a"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_big_sur: "62a2882f4193d6871d9c8116b897a8d33d6a4fedb954646a0eefdc4bfe623110"
    sha256 big_sur:       "6ae8cffb08f9cba4842a21fc92618e22403a474fbd6d05820c3755401d55688d"
    sha256 catalina:      "5d0157ff13610f06bc262350978ef1f754e2b7ed0721ba27c431cfd5b5b16639"
    sha256 mojave:        "9dd6fca906e634be1c1b05a99fa8f28735a969e3eb4d939048e89f322c3a4278"
    sha256 x86_64_linux:  "2626ed3b8a8e5448aabeac56f6fe91b199fe896a5fd84394d5475213fde1a139"
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
