class Grap < Formula
  desc "Language for typesetting graphs"
  homepage "http://www.lunabase.org/~faber/Vault/software/grap/"
  url "http://www.lunabase.org/~faber/Vault/software/grap/grap-1.45.tar.gz"
  sha256 "906743cdccd029eee88a4a81718f9d0777149a3dc548672b3ef0ceaaf36a4ae0"

  bottle do
    sha256 "4e4b22198d42beea1e531a6903f4085b67692e7da7bc1b7a3e51f42c235169d1" => :sierra
    sha256 "b9491c4bf9baeb0e9edc3cb0256f0199256b26fcc2fb76ac15153fd6f74c48f9" => :el_capitan
    sha256 "97c15c60c09da87b12c779fde541bff202f96327e76286a591d52a18b1c74d4e" => :yosemite
    sha256 "036bb10da8e432b027a2a88714d91e60ba3e297c94b8fe27ab48040e3800760b" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-example-dir=#{pkgshare}/examples"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
      .G1
      54.2
      49.4
      49.2
      50.0
      48.2
      43.87
      .G2
    EOS
    system bin/"grap", testpath/"test.d"
  end
end
