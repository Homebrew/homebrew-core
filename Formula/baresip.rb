class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/v2.0.1.tar.gz"
  sha256 "8e7a5d228d2003aec8b4e570a32de5937e9bcbceff14803198fba767c514d362"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "870fb04b4991dcaef48e6e573e2d218a60af6db40d7e7dfb01dedd96d317850c"
    sha256 arm64_big_sur:  "51640d9844c108a4cee14f4509356d6504dcb969167dc7696db6e72dfde4f58a"
    sha256 monterey:       "201f1b92b10298001f8fe73337e6e83a18e9ad10925d197e59b69b7853715ada"
    sha256 big_sur:        "8f5f01b5123e6f3a6d09809156b7fd01a5e5bff198f7195be5618b09249a94b5"
    sha256 catalina:       "8445b4d77fe127ad0aa9b52f3305089a67ac7f0451ebea3f5ad7d2a9c3d42c4d"
    sha256 x86_64_linux:   "3cc1b90ed2fb8ef0651f3a6f99081ee1426e8d9ebbe90ded5a082bd0793301db"
  end

  depends_on "libre"
  depends_on "librem"

  def install
    # baresip doesn't like the 10.11 SDK when on Yosemite
    if MacOS::Xcode.version.to_i >= 7
      ENV.delete("SDKROOT")
      ENV.delete("HOMEBREW_SDKROOT") if MacOS::Xcode.without_clt?
    end

    libre = Formula["libre"]
    librem = Formula["librem"]
    # NOTE: `LIBRE_SO` is a directory but `LIBREM_SO` is a shared library.
    args = %W[
      PREFIX=#{prefix}
      LIBRE_MK=#{libre.opt_share}/re/re.mk
      LIBRE_INC=#{libre.opt_include}/re
      LIBRE_SO=#{libre.opt_lib}
      LIBREM_PATH=#{librem.opt_prefix}
      LIBREM_SO=#{librem.opt_lib/shared_library("librem")}
      MOD_AUTODETECT=
      USE_G711=1
      USE_OPENGL=1
      USE_STDIO=1
      USE_UUID=1
      HAVE_GETOPT=1
      V=1
    ]
    if OS.mac?
      args << "USE_AVCAPTURE=1"
      args << "USE_COREAUDIO=1"
    end
    system "make", "install", *args
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
