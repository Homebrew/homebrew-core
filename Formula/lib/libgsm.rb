class Libgsm < Formula
  desc "Lossy speech compression library"
  homepage "https://www.quut.com/gsm/"
  url "https://www.quut.com/gsm/gsm-1.0.22.tar.gz"
  sha256 "f0072e91f6bb85a878b2f6dbf4a0b7c850c4deb8049d554c65340b3bf69df0ac"
  license "TU-Berlin-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?gsm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "73ab84857bda140ae2dbf8dcbba53376739db92a4943fa2aa5e9939ebe7365ba"
    sha256 cellar: :any,                 arm64_sonoma:  "b67bf46ae228c9cdb566c31cbf903c2b36933a43c225600420b7c95a41516601"
    sha256 cellar: :any,                 arm64_ventura: "873e314d6adc194af517d5e44f780822d23f39e19b13baec333bd28d990fa5ea"
    sha256 cellar: :any,                 sonoma:        "b3ffd6c44c59f8cba9394605a52ac959cd69d50dc2e4173cdb6ea395bdbc493b"
    sha256 cellar: :any,                 ventura:       "b8c2c17f921fb1fe0bdf21868c08d66b6792a14e419c4ac15ee0d4d79f15e628"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d58e3f81b1b007ea285d82e680f1dff3fae11ebce2bb2c712af0d2dd0cca343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a2e88a7ac1d423da03aba16b51e7eb10eb69925ad46fd98259c5bf054301600"
  end

  conflicts_with "toast", because: "both install `toast` binaries"

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
      %W[
        -shared
        -Wl,-soname,#{shared_library("libgsm", version.major.to_s)}
      ]
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
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lgsm", "-o", "test"
    system "./test"
  end
end
