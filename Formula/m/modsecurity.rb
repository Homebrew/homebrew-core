class Modsecurity < Formula
  desc "Libmodsecurity is one component of the ModSecurity v3 project"
  homepage "https://github.com/owasp-modsecurity/ModSecurity"
  url "https://github.com/owasp-modsecurity/ModSecurity/releases/download/v3.0.14/modsecurity-v3.0.14.tar.gz"
  sha256 "f7599057b35e67ab61764265daddf9ab03c35cee1e55527547afb073ce8f04e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef880da82b470f1bc5b1cce0c581ebeb87738b43f47d99928e7f90705a723d2c"
    sha256 cellar: :any,                 arm64_sonoma:  "d35bb9b47ef663af1e0d66564f39a3f70e600a891ab82d30349208a2ce01e620"
    sha256 cellar: :any,                 arm64_ventura: "fd6422cba66fea2a371e066e34a43ae75c2539ae7dc8d78c6e9198681a97e7cb"
    sha256 cellar: :any,                 sonoma:        "84fc44c8c036e373762e66acf75e21caf5e97cdfa24c4b03f50082694078414d"
    sha256 cellar: :any,                 ventura:       "f97fbde36e55908673885cae90d1bee0a5394f93fb97b10a8f3ad07acd061aee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a5ceccfc1aba5a91872111ed16bb5dc8d562b248135dff55dda9447f417bfc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7c83f85fb33704ab113e7f38f1cbc94d8105ed4ca0e5228ef524c73b04fd3e8"
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
