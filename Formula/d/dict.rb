class Dict < Formula
  desc "Dictionary Server Protocol (RFC2229) client"
  homepage "https://dict.org/bin/Dict"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.13.3/dictd-1.13.3.tar.gz"
  sha256 "192129dfb38fa723f48a9586c79c5198fc4904fec1757176917314dd073f1171"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "065e628c984ce455ed3ae85fa485098d829f343c5f1e68ab398fc4c77d57fe36"
    sha256 arm64_sequoia: "8ae52e0cd8200e05e9aab9b15269c4617b648079a1ccaf54879acc759eb268a9"
    sha256 arm64_sonoma:  "81d599c0cb61e67ee19ecc54293cac944568884b61d470fd50b0b30a1b8dae33"
    sha256 arm64_ventura: "5e07587d607e55a3ed72f4537dccb417b16e2cd463a6690f8ca8d508d520c919"
    sha256 sonoma:        "b6b358141e0bd18ba760ad85aee702004152e6d68d3cda9da560e519e4361c25"
    sha256 ventura:       "826e7bbdd50a8db3a8fd53b53b2183eb53f5cf107edb9adb3590ace085b16112"
    sha256 arm64_linux:   "a09aee6926baa5a91ec8f9e258d2d0b9fada22818a9be03e721df7dd853f1012"
    sha256 x86_64_linux:  "ae7ef43f713a5e828d33cfb43d4344ea6efb28809e95fdcdb47c06532fcb0705"
  end

  depends_on "libtool" => :build
  depends_on "libmaa"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    # Workaround for Xcode 14.3
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["ac_cv_search_yywrap"] = "yes"
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
    (prefix/"etc/dict.conf").write <<~EOS
      server localhost
      server dict.org
    EOS
  end

  test do
    assert_match "brewing or making beer.", shell_output("#{bin}/dict brew")
  end
end
