class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.22/krb5-1.22.1.tar.gz"
  sha256 "1a8832b8cad923ebbf1394f67e2efcf41e3a49f460285a66e35adec8fa0053af"
  # From Fedora: https://src.fedoraproject.org/rpms/krb5/blob/rawhide/f/krb5.spec
  license all_of: [
    "BSD-2-Clause",
    "BSD-2-Clause-first-lines",
    "BSD-3-Clause",
    "BSD-4-Clause",
    "Brian-Gladman-2-Clause",
    "CMU-Mach-nodoc",
    "FSFULLRWD",
    "HPND",
    "HPND-export2-US",
    "HPND-export-US",
    "HPND-export-US-acknowledgement",
    "HPND-export-US-modify",
    "ISC",
    "MIT",
    "MIT-CMU",
    "OLDAP-2.8",
    "OpenVision",
    any_of: ["BSD-2-Clause", "GPL-2.0-or-later"],
  ]

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "ba7292c48faba4e1316a134b578075438a4a5fd68ce7a26a078c01299a5ad567"
    sha256 arm64_sequoia: "f0f2b5564c2fd190fcd348e44fa173540229b6aeb0dbd0366c2dcd1c974b03bc"
    sha256 arm64_sonoma:  "9ed1b2fce50ddeb0895f6fc8ab6f063ee52a1b0247375b163819895ba90f10aa"
    sha256 sonoma:        "00825fbba0182d1fc4311fd0ab066f9171dbbfa5e054e8c3f9929711495cd649"
    sha256 arm64_linux:   "cefd51a8be00bb1f11891da5d751d9789033549a4b15270ee1d455d2dbb79d2c"
    sha256 x86_64_linux:  "f06847262502d82d12cc4db16ec946dffecbdd32c8835702c792b4ac38bc2b56"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "keyutils"
  end

  def install
    cd "src" do
      system "./configure", "--disable-nls",
                            "--disable-silent-rules",
                            "--without-system-verto",
                            *std_configure_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system bin/"krb5-config", "--version"
    assert_match include.to_s, shell_output("#{bin}/krb5-config --cflags")
  end
end
