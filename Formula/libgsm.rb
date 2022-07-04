class Libgsm < Formula
  desc "Lossy speech compression library"
  homepage "http://www.quut.com/gsm/"
  url "http://www.quut.com/gsm/gsm-1.0.20.tar.gz"
  sha256 "b0e6cf4d5ac81387cf74cbe431f77302db3b2f62fc7cb5e21a5670ac30963979"
  license "TU-Berlin-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?gsm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "560c62fce828d0f2fb3a4f83069aff197bb6edad19d863aedd0bdca1754ee547"
    sha256 cellar: :any, arm64_big_sur:  "6bc94981bf0d1334af48e47e8692d094367793b511a0df113a48266ab6f0c698"
    sha256 cellar: :any, monterey:       "747544181743e7a85f21ee67ca53b7f94652612c872a7b5eaef1525cff2e5731"
    sha256 cellar: :any, big_sur:        "c5bee474fc90a4c08f5e0b7e3eb589c363501cd479f2fdb5369e37c7d0824539"
    sha256 cellar: :any, catalina:       "9a3eaa556cd1a5429c458ee11c29b5c757ee6f32fbc334355110a37622357dc4"
    sha256 cellar: :any, mojave:         "f7a7683ef5f7f916e81e3ed51aa754da92ca2b993533608f8fc95187baaf8b3c"
    sha256 cellar: :any, high_sierra:    "5a2b52e7ed65f005f32bb56519dd425b26e537f888b49402322fe1424f0901e4"
  end

  def install
    # Use symlinks instead of hardlinks.
    inreplace "Makefile", "ln $? $@", "$(LN) $? $@"

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
