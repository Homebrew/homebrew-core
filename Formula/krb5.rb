class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://web.mit.edu/kerberos/dist/krb5/1.15/krb5-1.15.2.tar.gz"
  sha256 "1639e392edf25e3b6cfec2ae68f97eb53e07c2dbe74bfeede0108465d5d1c87e"

  bottle do
    sha256 "6795f2fc03f5fe5ee3caf2040d9ed6064e445fc06c2f7e1947007bf6ef32a084" => :high_sierra
    sha256 "31103d3d3f36f0b36082dba99702818aca880ab9f27634d59e290d6b98f46bcf" => :sierra
    sha256 "d10c24058b8a207ed2a33f8ee7f961af8bb8a63bcb98fb0ae8511a080ab96828" => :el_capitan
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
