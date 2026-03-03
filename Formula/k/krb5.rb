class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.22/krb5-1.22.2.tar.gz"
  sha256 "3243ffbc8ea4d4ac22ddc7dd2a1dc54c57874c40648b60ff97009763554eaf13"
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
  revision 1

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_tahoe:   "2968bf9d040cd58eb2933ddf03cd004d1f9abe8b19bd7f028ea8666ad47714ab"
    sha256 arm64_sequoia: "a9db2ba99f3e99279c4aac0277cdba955510d27f09bde6051b100e660c1a1c28"
    sha256 arm64_sonoma:  "b63debb64f3b2d7875f0868e5cefbe3375ff635df7f0d1e4fc76f3716cdbb3a5"
    sha256 sonoma:        "a4ab63ede148b1230e05c3002024e37d402ad3a18c98976d71a83920a879c462"
    sha256 arm64_linux:   "1e75b209585cd4b2155eb8eebadaf3c4df5948981fecfaa5633a60e5918a78d7"
    sha256 x86_64_linux:  "5c06477705002279f07de13c147866235a99abe1495ae4deb1eed805ec542245"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

  uses_from_macos "bison" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "e2fsprogs"
    depends_on "keyutils"
  end

  def install
    cd "src" do
      system "./configure", "--disable-nls",
                            "--disable-silent-rules",
                            "--with-system-et",
                            "--with-system-ss",
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
