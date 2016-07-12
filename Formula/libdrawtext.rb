class Libdrawtext < Formula
  desc "Library for anti-aliased text rendering in OpenGL"
  homepage "http://nuclear.mutantstargoat.com/sw/libdrawtext/"
  head "https://github.com/jtsiomb/libdrawtext.git"

  stable do
    url "http://nuclear.mutantstargoat.com/sw/libdrawtext/libdrawtext-0.3.tar.gz"
    sha256 "e9485a137ea898606b61445cc5b248b248b4f688b4d9d0a137f975193bfc9de4"

    # upstream commit "fixed bug in dtx_printf, uninitialized argument pointer"
    patch do
      url "https://github.com/jtsiomb/libdrawtext/commit/9e60bc82.patch"
      sha256 "22de3a8d66d8fa1991d0590ec7d77e14ac4aac7f5171026084f4c85d766a8009"
    end

    # upstream commit "removed dependency to glew"
    patch do
      url "https://github.com/jtsiomb/libdrawtext/commit/a8650760.patch"
      sha256 "3c502a8de284773d5ee1ab31c99f8c26f09bf36241529816e2039fb56ace7bc6"
    end

    # upstream commit "updated readme file" (notes that glew dep was removed)
    patch do
      url "https://github.com/jtsiomb/libdrawtext/commit/b4d06601.patch"
      sha256 "0cd16dbe636c6cf602730eb818ddad2ce12a60045c82116e73e891ce23db0099"
    end

    # upstream commit "Makefile.in: remove -lGLEW"
    patch do
      url "https://github.com/jtsiomb/libdrawtext/commit/c7acc36d.patch"
      sha256 "9d0b81f2bd9e995fda8024e6ef70a12f5ce3aaf6e9147f5068f1993c2a3948de"
    end
  end

  bottle do
    cellar :any
    sha256 "62d67858d4ac988f9b1c0717640061ddaac3d07253f833346ab03b5b95523e3d" => :el_capitan
    sha256 "3ec19e5df4406d47abe45f9c630b7bb78648cc1955d3b220ed53b0c010595f8c" => :yosemite
    sha256 "d4fe6c0cc2f75c6e41c7a2a39dec07dedf8e6122fe7069558ec2468334ec55fb" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"

  def install
    system "./configure", "--disable-dbg", "--enable-opt", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "-C", "tools/font2glyphmap"
    system "make", "-C", "tools/font2glyphmap", "PREFIX=#{prefix}", "install"
    pkgshare.install "examples"
  end

  test do
    cp "/System/Library/Fonts/LastResort.ttf", testpath
    system bin/"font2glyphmap", "LastResort.ttf"
    bytes = File.read("LastResort_s12.glyphmap").bytes.to_a[0..12]
    assert_equal [80, 54, 10, 53, 49, 50, 32, 50, 53, 54, 10, 35, 32], bytes
  end
end
