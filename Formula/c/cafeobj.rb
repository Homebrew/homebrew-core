class Cafeobj < Formula
  desc "New generation algebraic specification and programming language"
  homepage "https://cafeobj.org/"
  url "https://github.com/CafeOBJ/cafeobj/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "12780724a2b63ee45b12b79fd574ea1dc2870b59a4964ae51d9acc47dbbcff3d"
  license all_of: [
    "BSD-2-Clause",
    :public_domain, # comlib/let-over-lambda.lisp
    "MIT", # asdf.lisp
  ]
  head "https://github.com/CafeOBJ/cafeobj.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "4be3e504840ca27a601164e8bca0f8edaf6c6f6cda044f7c50736041957e8492"
    sha256 arm64_monterey: "795c8a702f4db1bdb7e64c100f5959cfdbdeacefe813f4acbbd09fb38460eef3"
    sha256 arm64_big_sur:  "0a68da082b8adb250f4041991f1f7a9b61e8f9a93012b9cd15e9c1b80b27680b"
    sha256 ventura:        "09a50d00fb9193709372416b990d34e74beb4ff09b8ae9ea280d238363cd356b"
    sha256 monterey:       "afad90131b9fb0a6566817ddc18dc9d98be0170eb3e6071f457fa31bf81a868e"
    sha256 big_sur:        "f4337d1c194cc66630e2ea78b2d532b59971ec19ad422a11ea515d23cad46f3c"
  end

  depends_on "sbcl"

  def install
    system "./configure", "--with-lisp=sbcl", "--prefix=#{prefix}", "--with-lispdir=#{share}/emacs/site-lisp/cafeobj"
    system "make", "install"
  end

  test do
    system "#{bin}/cafeobj", "-batch"
  end
end
