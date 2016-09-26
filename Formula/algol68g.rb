class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  url "https://jmvdveer.home.xs4all.nl/algol68g-2.8.3.tar.gz"
  sha256 "568bc93950463f8a70c3973097360945a4dfb300c422a8410cfc638d6ba548e7"

  bottle do
    sha256 "35d3ba002e09ec60ff236c6d0a6fcc815ea49f5e9b40f0155057b22da87e1245" => :sierra
    sha256 "467a5892fd9cdd854eaabb2b298dbc55bc8dec961960ef54e5730f6854d388f8" => :el_capitan
    sha256 "6f4ba5db40637d0a5d10d0f416854e2497d59ec43abc108484a3420f36903323" => :yosemite
    sha256 "5ec387dbb47eeeca93019a449ced1e7e5472f0ada413e19258c81cb3ec41d76d" => :mavericks
  end

  depends_on "gsl" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<-EOS.undent
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
