class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://web.mit.edu/kerberos/dist/krb5/1.15/krb5-1.15.2.tar.gz"
  sha256 "1639e392edf25e3b6cfec2ae68f97eb53e07c2dbe74bfeede0108465d5d1c87e"

  bottle do
    sha256 "9b87403ac183433912e366149ec8ecaf3a440762e0354988d5e8682f30618b6d" => :high_sierra
    sha256 "8714f6c0fb08a4a97a045118b531dfcb92932a8e3b5b1ffab5426d5afb813d68" => :sierra
    sha256 "d377c4d4eb089e644e669fca49f9e157f4124761ae29ce29aabaee5c6e519c36" => :el_capitan
    sha256 "c0aaa3b9ab1a355542ce062e8336173f347a6dd2ba4eec46367f0963abffaa33" => :yosemite
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
