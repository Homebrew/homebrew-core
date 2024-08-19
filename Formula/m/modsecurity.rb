class Modsecurity < Formula
  desc "Libmodsecurity is one component of the ModSecurity v3 project"
  homepage "https://github.com/owasp-modsecurity/ModSecurity"
  url "https://github.com/owasp-modsecurity/ModSecurity/releases/download/v3.0.12/modsecurity-v3.0.12.tar.gz"
  sha256 "a36118401641feef376bb469bf468abf94b7948844976a188a6fccb53390b11f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "722e5f5abf8310c4d78601ac2fd5cb1e584b48aa8e443bf953d6b38f871412e8"
    sha256 cellar: :any,                 arm64_ventura:  "2a2dbe4b8599b84925e416bbe25513afb215a4ac4435147b89bfb61fe8ffb922"
    sha256 cellar: :any,                 arm64_monterey: "a72bc5b6bd641c4b31c3fdaf740ad0cf9c0923552c83aa4c6087860c73b6140b"
    sha256 cellar: :any,                 sonoma:         "ea2577a3e089345500bd3ede0832feed3c5c8ff5fe995e2ddaa74316b0be3824"
    sha256 cellar: :any,                 ventura:        "e30599a845c0fbdf4228706903af022c0535079db7fac80141eb2fbe46dea1e4"
    sha256 cellar: :any,                 monterey:       "331bbd6821ff365251e335fe58efed6581ff41abdb87dacd845403bc2f6eaac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "924add172031a6d2ff64d54486d15bf32e0f0aeb0fd9c1ce3629efc098573f70"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
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
      "--with-libxml=#{libxml2}",
      "--with-lua=#{Formula["lua"].opt_prefix}",
      "--with-pcre2=#{Formula["pcre2"].opt_prefix}",
      "--with-yajl=#{Formula["yajl"].opt_prefix}",
      "--without-geoip",
    ]

    system "./configure", *args, *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/modsec-rules-check \"SecAuditEngine RelevantOnly\"")
    assert_match("Test ok", output)
  end
end
