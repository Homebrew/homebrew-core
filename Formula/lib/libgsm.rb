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
    sha256 cellar: :any,                 arm64_sequoia:  "93cefc094ad064330c51f5fc139343cfe13d3554ca3e1fcd28bf1af3240829fc"
    sha256 cellar: :any,                 arm64_sonoma:   "7733596095803d3248e23e37224e5914d39560ae476b9d282f79b59f6a5b05c5"
    sha256 cellar: :any,                 arm64_ventura:  "99fc0cf57ca6ccb2fca847f53f5201347e58c10b2a50c9f766319029d57a6556"
    sha256 cellar: :any,                 arm64_monterey: "3adbd0618b07bd0546aed790ae76275b5a5c4ea4f822f5375b358339f8c73e53"
    sha256 cellar: :any,                 arm64_big_sur:  "a65d58777535fd4113ba3d9b667d4b7710e51311e218b947f0977d279288fcda"
    sha256 cellar: :any,                 sonoma:         "15fde999ee045e12dadcc18c5eed373cdf485d78ba97174c8587c4031e317910"
    sha256 cellar: :any,                 ventura:        "17604726bbc6db357dfb44a26a2c8ca4cde02c7ff11fc547b940e15c6ae68350"
    sha256 cellar: :any,                 monterey:       "b7746165e220e043311776189b8739dd8bc6c2b83cb101d409b563a647195ad6"
    sha256 cellar: :any,                 big_sur:        "60591d316a866bb64d58b718627103ffe1adf71d4665baf491c9c5454bc172ca"
    sha256 cellar: :any,                 catalina:       "fc559f8e94bc509708df438b830ec4276260e108f91ece47b5a7d3a1293fa498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2398c2265658796adac35f2494dc97e0bd4fa6e20d1fd7bd70d15ea389782a05"
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
