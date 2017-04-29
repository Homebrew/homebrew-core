class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "http://web.mit.edu/kerberos/dist/krb5/1.15/krb5-1.15.1.tar.gz"
  sha256 "437c8831ddd5fde2a993fef425dedb48468109bb3d3261ef838295045a89eb45"

  bottle do
    sha256 "a8dcbc521a970ac8025d588553e30bb5d2d3ef627d9d440c85dc35ae9e91ad48" => :sierra
    sha256 "a3330737603312971c3774d11b2ed6266cc032aa7a7395b2c0d6fba2313b2e1c" => :el_capitan
    sha256 "cd615e303ffccfabd5dfd6c112c5882b54bd6e55003f62af2d6ee0e6d5c941bc" => :yosemite
  end

  keg_only :provided_by_osx

  depends_on "openssl"

  def install
    cd "src" do
      system "./configure",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}"
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
