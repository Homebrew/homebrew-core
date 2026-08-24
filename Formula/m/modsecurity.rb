class Modsecurity < Formula
  desc "Libmodsecurity is one component of the ModSecurity v3 project"
  homepage "https://github.com/owasp-modsecurity/ModSecurity"
  url "https://github.com/owasp-modsecurity/ModSecurity/releases/download/v3.0.16/modsecurity-v3.0.16.tar.gz"
  sha256 "739be3c71b1939f14e91afe1eeae654acbd440da11bd29790458840bc315b4c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c5da00e5e5acf53ce53798e9e0bfcd768d6b46f4063ca021d589165d00a7cd84"
    sha256 cellar: :any, arm64_sequoia: "ed15406a6e8b0194ba73746044697c4b89941c1aeffe7cb470f5510fc2a96366"
    sha256 cellar: :any, arm64_sonoma:  "2defe052614124fa7e20e16358c4d18429009a78028d9bb1bb0eff5d04f19878"
    sha256 cellar: :any, sonoma:        "48b159b5e26675c53e6fe6d0f54d8d77cfe3b9f5b5b3a29859a6d61f97b71a68"
    sha256 cellar: :any, arm64_linux:   "00cb4763e7114913214907f09f3064aa5d31c1b01468ddef6dd27f9591b4f81c"
    sha256 cellar: :any, x86_64_linux:  "44b13d984cff8b0f4b75ac029cc6bf69f55990dea11efd4e2902753113350a2f"
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
