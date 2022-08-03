class Libgsm < Formula
  desc "Lossy speech compression library"
  homepage "http://www.quut.com/gsm/"
  url "http://www.quut.com/gsm/gsm-1.0.21.tar.gz"
  sha256 "7d8439fc6ed8bfba1a85011f26800b2afee78b96555c9ed9ce9d3024d4da7754"
  license "TU-Berlin-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?gsm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dcfb808cefed20861e0b01599e8ecd4e481ca027f01f95375374282bd79dc2db"
    sha256 cellar: :any,                 arm64_big_sur:  "61809769fd4dfa2861d124adff592cb0ddf6cafe5c811e234a301e9308904b22"
    sha256 cellar: :any,                 monterey:       "875886ea26fffce6b0bf2fc8714fbd1957057b935bebfbdf377e13a72cc01f00"
    sha256 cellar: :any,                 big_sur:        "6e06bdf7008ab6528ea64717987f7776feeecd2ae5096d0beff91d2489ea2e48"
    sha256 cellar: :any,                 catalina:       "8311bfbdfa498a544f1af991a6b944d9fdce02080526415acd31ffb897ee1857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d71debd75bd7890a991a2d03965f0e26ca6cd390cb48a1b8cda496674ead9a26"
  end

  def install
    # Only the targets for which a directory exists will be installed
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath
    man3.mkpath

    arflags = if OS.mac?
      %W[
        -dynamiclib
        -compatibility_version #{version.major}
        -current_version #{version}
        -install_name #{lib/shared_library("libgsm", version.major.to_s)}
      ]
    else
      ["-shared"]
    end
    arflags << "-o"

    args = [
      "INSTALL_ROOT=#{prefix}",
      "GSM_INSTALL_INC=#{include}",
      "GSM_INSTALL_MAN=#{man3}",
      "TOAST_INSTALL_MAN=#{man1}",
      "LN=ln -s",
      "AR=#{ENV.cc}",
      "ARFLAGS=#{arflags.join(" ")}",
      "RANLIB=true",
      "LIBGSM=$(LIB)/#{shared_library("libgsm", version.to_s)}",
    ]
    args << "CC=#{ENV.cc} -fPIC" if OS.linux?

    # We need to `make all` to avoid a parallelisation error.
    system "make", "all", *args
    system "make", "install", *args

    # Our shared library is erroneously installed as `libgsm.a`
    lib.install lib/"libgsm.a" => shared_library("libgsm", version.to_s)
    lib.install_symlink shared_library("libgsm", version.to_s) => shared_library("libgsm")
    lib.install_symlink shared_library("libgsm", version.to_s) => shared_library("libgsm", version.major.to_s)
    lib.install_symlink shared_library("libgsm", version.to_s) => shared_library("libgsm", version.major_minor.to_s)

    # Build static library
    system "make", "clean"
    system "make", "./lib/libgsm.a"
    lib.install "lib/libgsm.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gsm.h>

      int main()
      {
        gsm g = gsm_create();
        if (g == 0)
        {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgsm", "-o", "test"
    system "./test"
  end
end
