class Modsecurity < Formula
  desc "Libmodsecurity is one component of the ModSecurity v3 project"
  homepage "https://github.com/owasp-modsecurity/ModSecurity"
  url "https://github.com/owasp-modsecurity/ModSecurity/releases/download/v3.0.17/modsecurity-v3.0.17.tar.gz"
  sha256 "f283b33d5c21130fd3a15c84a93a1abe12bd1949edaf44288b12af571b671a50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "69455a24d9a40cd015552a36f685d73db4042af46b3dd88dcc97f203556fd1cd"
    sha256 cellar: :any, arm64_tahoe:       "8794c92d822c313a32a8dbc3c98f12e12059e18665422530360827ca4c5f253e"
    sha256 cellar: :any, arm64_sequoia:     "ce76ad59f0b43361b075163bc96f29c43fb2ac3b31a38aa4fc52022dfe6c5e1b"
    sha256 cellar: :any, arm64_linux:       "781a0525ebad7674ad0b47b5663f7611876f69a3ce26586444b8cd335096273a"
    sha256 cellar: :any, x86_64_linux:      "5f9294bde5c2fa6d90dc3aefdce89f0bb00e0ec4f637ae520472d312d610deea"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libmaxminddb"
  depends_on "lua"
  depends_on "pcre2"
  depends_on "yajl"

  uses_from_macos "curl", since: :monterey
  uses_from_macos "libxml2"

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    libxml2 = OS.mac? ? "#{MacOS.sdk_path}/usr" : formula_opt_prefix("libxml2")

    args = [
      "--disable-debug-logs",
      "--disable-doxygen-html",
      "--disable-examples",
      "--disable-silent-rules",
      "--with-libxml=#{libxml2}",
      "--with-lua=#{formula_opt_prefix("lua")}",
      "--with-pcre2=#{formula_opt_prefix("pcre2")}",
      "--with-yajl=#{formula_opt_prefix("yajl")}",
      "--without-geoip",
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/modsec-rules-check \"SecAuditEngine RelevantOnly\"")
    assert_match("Test ok", output)
  end
end
