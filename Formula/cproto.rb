class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7r.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.7r.orig.tar.gz"
  sha256 "36641744094baee2883044595659b529787dd295a75584a2bc2cbf250b0c3e1b"
  license all_of: [
    :public_domain,
    "MIT",
    "GPL-3.0-or-later" => { with: "Autoconf-exception-3.0" },
  ]

  livecheck do
    url "https://invisible-mirror.net/archives/cproto/"
    regex(/href=.*?cproto[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "08f390dd44633ad2e1ca5018496adb855e8786d3584f69ff2283e05cc00214b2" => :big_sur
    sha256 "0175783f96e502a01fc60f8931e5c803875d1f04ac39be006cbc695535375722" => :arm64_big_sur
    sha256 "0359e4506a282356c97f5973ebadb1bef2fa9fe87aca8e3f073922a8ce40b3f8" => :catalina
    sha256 "92d8a89a3921677c7aadf9c74555de8365357e1844705d08c24905c989c2f9b3" => :mojave
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"woot.c").write("int woot() {\n}")
    assert_match(/int woot.void.;/, shell_output("#{bin}/cproto woot.c"))
  end
end
