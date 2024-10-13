class Dict < Formula
  desc "Dictionary Server Protocol (RFC2229) client"
  homepage "https://dict.org/bin/Dict"
  url "https://downloads.sourceforge.net/project/dict/dictd/dictd-1.13.1/dictd-1.13.1.tar.gz"
  sha256 "e4f1a67d16894d8494569d7dc9442c15cc38c011f2b9631c7f1cc62276652a1b"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia:  "4175e6d386524d1f9ad1b71cef3b595b2f735cb239ced16ffb7ff56ac43372e5"
    sha256 arm64_sonoma:   "72952615034fd444a7b5d98c38c0f86ad93b6658b03656a3565e677acc8d7a06"
    sha256 arm64_ventura:  "4c103b9ceaf30219f6172ec2f23ea4da33c91b6aeddfc8f5fb06306b1fa526a0"
    sha256 arm64_monterey: "5905bf4d882c4377c3158a91411b2909e8c5bfe9cf6f738f1b349deb499c3a7d"
    sha256 sonoma:         "fdc1aa1d8f3e9570cccdf86ff54d7c81e276204ddf4dea9cba4551f096b014c2"
    sha256 ventura:        "243021700916adc3db25a32a6309b73952d16dba189d4835533b3557780dcb32"
    sha256 monterey:       "474cb13091b6544d4a0141c7cc01c2f9e127a7b98d3b737de49627a304773aa1"
    sha256 x86_64_linux:   "d2cc0059c1e1471f2bd5ad1f871f2ea6a57f486bbcb0f9761a65b3f5dc412caf"
  end

  depends_on "libtool" => :build
  depends_on "libmaa"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    # Workaround for Xcode 14.3
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["LIBTOOL"] = "glibtool"
    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
    (prefix+"etc/dict.conf").write <<~EOS
      server localhost
      server dict.org
    EOS
  end

  test do
    assert_match "brewing or making beer.", shell_output("#{bin}/dict brew")
  end
end
