class Modsecurity < Formula
  desc "Libmodsecurity is one component of the ModSecurity v3 project"
  homepage "https://github.com/owasp-modsecurity/ModSecurity"
  url "https://github.com/owasp-modsecurity/ModSecurity/releases/download/v3.0.14/modsecurity-v3.0.14.tar.gz"
  sha256 "f7599057b35e67ab61764265daddf9ab03c35cee1e55527547afb073ce8f04e8"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bb41a2f71c67c4e99049408bbe318e1cf2c0b10e4e90fe992b3f79fb7055a69"
    sha256 cellar: :any,                 arm64_sequoia: "a1755b42fb4b7ec87ce91063516a2ad3556164d298c3929ff7cd2719edd33dcb"
    sha256 cellar: :any,                 arm64_sonoma:  "3fd03a5329efea1ca34f0a9cd0c4b7dd166dd30bbe8b119aa4399745f04b6c47"
    sha256 cellar: :any,                 sonoma:        "d4b19335eeb71851802f1de03b6c5348a8211cc0bf0ecd289370dcd160c0330d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c637476b9bbc85fb184b6a4e1f5893d6dcd2aca6f489699b9fe4cc02f82e3e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ee186488795d3a79d22170d0cf241b9ca2702b2dac511b89287417f9840eb6e"
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

  # Use ArchLinux patch to fix build with libxml2 2.12.
  # TODO: Check if fixed in future libxml2 release.
  # Issue ref: https://github.com/owasp-modsecurity/ModSecurity/issues/3023
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/libmodsecurity/-/raw/5c78cfaaeb00c842731c52851341884c74bdc9b2/libxml-includes.patch"
    sha256 "7ee0adbe5b164ca512c49e51e30ffd41e29244156a695e619dcf1d0387e69aef"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    libxml2 = OS.mac? ? "#{MacOS.sdk_path_if_needed}/usr" : Formula["libxml2"].opt_prefix

    args = [
      "--disable-debug-logs",
      "--disable-doxygen-html",
      "--disable-examples",
      "--disable-silent-rules",
      "--with-libxml=#{libxml2}",
      "--with-lua=#{Formula["lua"].opt_prefix}",
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
