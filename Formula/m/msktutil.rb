class Msktutil < Formula
  desc "Active Directory keytab management"
  homepage "https://github.com/msktutil/msktutil"
  url "https://github.com/msktutil/msktutil/releases/download/1.2.2/msktutil-1.2.2.tar.bz2"
  sha256 "51314bb222c20e963da61724c752e418261a7bfc2408e7b7d619e82a425f6541"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "637b97314f04b43d95e6fea26acf3f8f531270aa5d1ce61e6b1622d9f54e6b22"
    sha256 cellar: :any,                 arm64_sequoia: "1d4a594ffcf5627ca1fb5781078661711c3a1c63b5b8542a140c0a0f44bbc4e3"
    sha256 cellar: :any,                 arm64_sonoma:  "a9c6eb346f0a7bbc6f71fd72742fc908ded087b432c75ffaeab22b9308492af2"
    sha256 cellar: :any,                 arm64_ventura: "dafafc71f2995c54f1b3ec393dda0fd0b68961d7bfd943ef795a26a8a5e18172"
    sha256 cellar: :any,                 sonoma:        "3fcc25c8edbcb71d193079ba3108263410cc9b9057b51f9d995ba499982795cc"
    sha256 cellar: :any,                 ventura:       "02776a3d462787e70fc5fc13dcda29929faa694c073db369119d6c34e16f7e40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69a7a6390216722bbba0e2b1c6b3dcf7aef66cfd3625c2ff4a93c9647d14f157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "667123d6e8cd021378d8fd1bc556d0756dd9e694972b29c0fbc282716c8626a7"
  end

  # macos builtin krb5 has `krb5-config reports unknown vendor Apple MITKerberosShim` error
  depends_on "krb5"

  uses_from_macos "cyrus-sasl"
  uses_from_macos "openldap"

  def install
    system "./configure", "--disable-silent-rules",
                          "--mandir=#{man}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/msktutil --version")
  end
end
