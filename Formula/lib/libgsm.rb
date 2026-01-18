class Libgsm < Formula
  desc "Lossy speech compression library"
  homepage "https://www.quut.com/gsm/"
  url "https://www.quut.com/gsm/gsm-1.0.23.tar.gz"
  sha256 "8b7591a85ac9adce858f2053005e6b2eb20c23b8b8a868dffb2969645fa323c0"
  license "TU-Berlin-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?gsm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "467a477395955a57baa2c5dbf6f569d9954e11f4345709ebcf1bfe5a97bfbb1e"
    sha256 cellar: :any,                 arm64_sequoia: "658ac922d39d58336a7e0b2a98674de725a9f56d861a5375c1b386fb213e3d74"
    sha256 cellar: :any,                 arm64_sonoma:  "8f156675b7d5842149a55b6db6f094814d6b0420b6b1a12352597ab48db5907d"
    sha256 cellar: :any,                 arm64_ventura: "92acf1ef6c9554599abb3350fd3dc1c8ccfe6b640a321c3e91b5a31cfb3df5f5"
    sha256 cellar: :any,                 sonoma:        "eeb8b9463ce92eb6d50dffa097e3328a9ae652ad5d7fb018addb5a439a037e05"
    sha256 cellar: :any,                 ventura:       "d39392bfba634df95d672415b63c2a6aa826855853cf83b55a296bcc189750bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d0967b1520c0d352be35cd5643aadf8efa15e4a19bbf8a1c573cff46800514a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67f98c00f51b40a421b86df456643a127da384044f36bb9261fe9c2bea97436b"
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
