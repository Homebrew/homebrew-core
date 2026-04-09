class Modsecurity < Formula
  desc "Libmodsecurity is one component of the ModSecurity v3 project"
  homepage "https://github.com/owasp-modsecurity/ModSecurity"
  url "https://github.com/owasp-modsecurity/ModSecurity/releases/download/v3.0.14/modsecurity-v3.0.14.tar.gz"
  sha256 "f7599057b35e67ab61764265daddf9ab03c35cee1e55527547afb073ce8f04e8"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "903816449f1b48c8e20a657b978b80f93ee3f721ebb78a6c1216260983c60b67"
    sha256 cellar: :any,                 arm64_sequoia: "1e5fb4a1da5ca02302211054c1222e58fe142f4e4b9d51a6abcbbd1e6e4f93c8"
    sha256 cellar: :any,                 arm64_sonoma:  "128cab434340b33ad4ce2d710e02483d56bc7cf6a91e10dfb677f631f0c2b093"
    sha256 cellar: :any,                 sonoma:        "c6e2865897da1cffe2d77764b905edd4c400af92385ffe32f9348cefea29f023"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90659a4c8e50293d7415e09a0e79e9f25bdca5af7cb54eb1134714ce40cd564f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81c9b619a94eff97ee7e49985eaf493b984130de34f608eda9b283a94b64c538"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libmaxminddb"
  depends_on "lua@5.4"
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
