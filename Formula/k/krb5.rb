class Krb5 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.22/krb5-1.22.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/krb5-1.22.2.tar.gz"
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
  revision 2
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/Current release: .*?>krb5[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 arm64_golden_gate: "678c05de46229f5b35631196808a7f6e4a32f9a18bc9574ec447f6c8290dfff7"
    sha256 arm64_tahoe:       "8fc14b442b666d56a994cfddb47cd86071b6408905be70f10f7fcf668fc9e1cf"
    sha256 arm64_sequoia:     "8bc2adf379fd6e0d0dd3bbe663effe87f625f25b9aa5a1bac71aef4b450ccc23"
    sha256 arm64_linux:       "ac8557d7c89e6ee7e4d736baf925469fefe3837b1aa804623b0638a227f5567d"
    sha256 x86_64_linux:      "587ada42216850382fedbfa4707b7aed405fb6934d8ed0650567a7a488162d1c"
  end

  keg_only :provided_by_macos

  depends_on "openssl@4"

  uses_from_macos "bison" => :build

  on_linux do
    depends_on "keyutils"
  end

  # Add support for OpenSSL 4
  patch do
    url "https://github.com/krb5/krb5/commit/ceee5d558a2be93a9b2df717be1ea42c5d83ee51.patch?full_index=1"
    sha256 "f7af91992fa6c825a4d42bcc138cd521aa8b98d723f9301c3d39acc4e780d249"
    type :backport
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
