class Abnfgen < Formula
  desc "Quickly generate random documents that match an ABFN grammar"
  homepage "http://www.quut.com/abnfgen/"
  url "http://www.quut.com/abnfgen/abnfgen-0.19.tar.gz"
  sha256 "3d7649b1a46a8c65a7003228182ca9b15921ac2563555e9fd23b64a69ff050c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "c076c1c5b9f8cbf09d69b262ceba8c47b51841254adcb3dec4acd8b4377f9b15" => :high_sierra
    sha256 "9149eecb8a894d8865f7d42be648ca8c08716843424b4c7b42e5e61e03dcf04e" => :sierra
    sha256 "814a6fe9303958066f5dd733645efd556785df95c212d6b811e7e57da90ffa25" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"grammar").write 'ring = 1*12("ding" SP) "dong" CRLF'
    system "#{bin}/abnfgen", (testpath/"grammar")
  end
end
