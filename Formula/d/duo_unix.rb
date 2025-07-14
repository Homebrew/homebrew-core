class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://github.com/duosecurity/duo_unix/archive/refs/tags/duo_unix-2.1.0.tar.gz"
  sha256 "29666b135d577c91f2a89730e18808d98c3a5c75a462dd3181fdc0cec5ae72c1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "1cd758e3427dfaa7a1a2a284ce476934f234a52351d0d3af9b7d3689c2d49383"
    sha256 arm64_sonoma:  "5b082a4d6c08755254f63997bc37a1a1777bcc22b358740b3db075215213ca1d"
    sha256 arm64_ventura: "f249c95d4e3e81555b2e84eca807456f5ad25551b04ba6a8b438da1f9bfbf561"
    sha256 sonoma:        "8645ee577645d4d7b28304df06edb5d1477ec20ed1fa1ef1133c06f20b289745"
    sha256 ventura:       "9991909cb62c285d217000dcd1c00b633e1ed96fa9cb1cd0cde69af40ac70af8"
    sha256 arm64_linux:   "f29d7f096f966eb543b0d727afdee0812996cc1accbbc9c681d990bc0644876b"
    sha256 x86_64_linux:  "b60c4758d2786248237e8c94f022c80479bfe45c22f65c62180145f0f091a880"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    File.write("build-date", time.to_i)
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
