class Modsecurity < Formula
  desc "Libmodsecurity is one component of the ModSecurity v3 project"
  homepage "https://github.com/owasp-modsecurity/ModSecurity"
  url "https://github.com/owasp-modsecurity/ModSecurity/releases/download/v3.0.15/modsecurity-v3.0.15.tar.gz"
  sha256 "c276c838df6b61d96aa52075aee17d426af52755e16d09edca9f9d718696fda7"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e51b958e7f3ec2ebe0324cb0f133aa6af929c429d22589bb042ac5a9f524eeb7"
    sha256 cellar: :any,                 arm64_sequoia: "47d9a27168331fe29ea86eb6c398a94ee9c0d7c2a295ab62cdf2364e5de29d73"
    sha256 cellar: :any,                 arm64_sonoma:  "fc6b93dc556fc26c55831e5c0365fdc6e45261dcf8ecb3a6271ac6a49f6c48f9"
    sha256 cellar: :any,                 sonoma:        "8bfd7a7e85fe4102ae34638c5bdd7a3c5135aa57e5610f7411c069c47788f050"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8efcb21e3ece35ac7c3df4bc83c0b38f10ce86881d45f80098a0946ef9467aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c901de2b4e8c412d29aa69ac9974a0e52786fa689172619c72269904e3b3685"
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

    libxml2 = OS.mac? ? "#{MacOS.sdk_path_if_needed}/usr" : Formula["libxml2"].opt_prefix

    args = [
      "--disable-debug-logs",
      "--disable-doxygen-html",
      "--disable-examples",
      "--disable-silent-rules",
      "--with-libxml=#{libxml2}",
      "--with-lua=#{Formula["lua@5.4"].opt_prefix}",
      "--with-pcre2=#{Formula["pcre2"].opt_prefix}",
      "--with-yajl=#{Formula["yajl"].opt_prefix}",
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
