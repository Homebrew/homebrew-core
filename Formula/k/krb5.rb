class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.22/krb5-1.22.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/krb5-1.22.3.tar.gz"
  sha256 "fe90af8441ad9fa9b064b8e53077cefb782a96f8a68276b031dc54af1789ff0b"
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
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_golden_gate: "9ee71115230780fcf77473cbe412f3abea1b7ec672b0d9c34c70b59d39902dbc"
    sha256 arm64_tahoe:       "4827d11086d9f6d699be5403572eb6e9fbef3699c2f8c7001947eb78f2d6b384"
    sha256 arm64_sequoia:     "465873b2f5bb5751fc01e086648cb54fc30a4b975e3bc00e393e00e763931015"
    sha256 arm64_linux:       "aa9e5353cb1afed5c356c3741005707f7658ba5062f8cdbe3f094cce09af5a08"
    sha256 x86_64_linux:      "6bea50f9570bb1e8e9fb3d9e8a2eab31c5ee01edb700b347e63679e0659ee61b"
  end

  keg_only :provided_by_macos

  depends_on "openssl@4"

  uses_from_macos "bison" => :build

  on_linux do
    depends_on "keyutils"
  end

  deny_network_access!

  def install
    cd "src" do
      # libgssrpc calls secure_getenv, which falls back to k5_secure_getenv
      # from libkrb5support where libc lacks it (e.g. macOS).
      inreplace "lib/rpc/Makefile.in", "-lk5crypto $(COM_ERR_LIB)", "-lk5crypto $(SUPPORT_LIB) $(COM_ERR_LIB)"

      # OpenSSL 4.1 returns const pointers from X509_get_ext() and X509_get_subject_name().
      inreplace "plugins/tls/k5tls/openssl.c" do |s|
        s.sub! "    X509_EXTENSION *san_ext;", "    const X509_EXTENSION *san_ext;"
        s.sub! "    X509_NAME *name;", "    const X509_NAME *name;"
      end

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
