class Expect < Formula
  desc "Program that can automate interactive applications"
  homepage "https://expect.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/expect/Expect/5.45.4/expect5.45.4.tar.gz"
  sha256 "49a7da83b0bdd9f46d04a04deec19c7767bb9a323e40c4781f89caf760b92c34"

  bottle do
    rebuild 1
    sha256 "f7c101cd2eec5832de103e3535e876de15b53a96a301d4848990ab8af992f3a6" => :catalina
    sha256 "668b4fb12eed5bbf783e8b4ec52dad24b88f38af5577ba1e45ed9947e50e50ef" => :mojave
    sha256 "a0c6ffe797dc0bbe512b628819acee67a7a9b00573b6433fe0672285d41a9df1" => :high_sierra
    sha256 "fc9ad781caaf8d45f47a87d4303645faa2e600852c73fd5432f0be2e588e95f2" => :sierra
    sha256 "4fcb163b1b1e7e209b632c43ba03106ca1c4e4d6a745260b813d28a803581e58" => :el_capitan
  end

  # Autotools are introduced here to regenerate configure script. Remove
  # if the patch has been applied in newer releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  uses_from_macos "tcl-tk"

  def install
    args = %W[
      --prefix=#{prefix}
      --exec-prefix=#{prefix}
      --mandir=#{man}
      --enable-shared
      --enable-64bit
      --with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework
    ]

    ENV.prepend "CFLAGS",
      "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework/Versions/8.5/Headers/tcl-private"

    # Regenerate configure script. Remove after patch applied in newer
    # releases.
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *args
    system "make"
    system "make", "install"
    lib.install_symlink Dir[lib/"expect*/libexpect*"]
  end

  test do
    system "#{bin}/mkpasswd"
  end
end
