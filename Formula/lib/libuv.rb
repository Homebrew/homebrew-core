class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/v1.46.0.tar.gz"
  sha256 "7aa66be3413ae10605e1f5c9ae934504ffe317ef68ea16fdaa83e23905c681bd"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "483977e99e68aa3e257b35af9bf75d7806d2a9a05e7ca9a696087c612be1e968"
    sha256 cellar: :any,                 arm64_ventura:  "8c3beb4d11ed0d45cf0b7e07d280ff815eab9f9c138eec90a2f824168aed039e"
    sha256 cellar: :any,                 arm64_monterey: "bfaeee8ea65a26b881951c90d5ec1f4000039f228a4198735c015309307c47d9"
    sha256 cellar: :any,                 arm64_big_sur:  "1f1c49121e9a4df9eb520aceac58781a3ee61364370f04096ddc043842c8beda"
    sha256 cellar: :any,                 sonoma:         "cf983ebc487161ba5329c3da86081d61dd17a7f2c29302584a30e4f076ae3705"
    sha256 cellar: :any,                 ventura:        "68085c874a3df5a9dc0a6a86bbce91ef370373523602fcbb31a63d37f259e025"
    sha256 cellar: :any,                 monterey:       "38513d0917c18b294afadbca1ad005d73c450f3a06a5afcd2396398f428157ad"
    sha256 cellar: :any,                 big_sur:        "f75b27c39a13b279554a2c6f5c0451d54af1c9f7abc312e6c5e50ae3f346599d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad3f4af550bc5b9256f9d2c73bce18e335adf185052d9dec5dd44c1c142f961c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    # This isn't yet handled by the make install process sadly.
    cd "docs" do
      system "make", "man"
      system "make", "singlehtml"
      man1.install "build/man/libuv.1"
      doc.install Dir["build/singlehtml/*"]
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uv.h>
      #include <stdlib.h>

      int main()
      {
        uv_loop_t* loop = malloc(sizeof *loop);
        uv_loop_init(loop);
        uv_loop_close(loop);
        free(loop);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-luv", "-o", "test"
    system "./test"
  end
end
