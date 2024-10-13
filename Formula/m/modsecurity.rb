class Modsecurity < Formula
  desc "Libmodsecurity is one component of the ModSecurity v3 project"
  homepage "https://github.com/owasp-modsecurity/ModSecurity"
  url "https://github.com/owasp-modsecurity/ModSecurity/releases/download/v3.0.13/modsecurity-v3.0.13.tar.gz"
  sha256 "86b4881164a161b822a49df3501e83b254323206906134bdc34a6f3338f4d3f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "28915cb87fa22a69e9975175c8752811a070de7ac3c7abd731bf983d07cd4852"
    sha256 cellar: :any,                 arm64_sonoma:   "feb85b8f1d5cfe4992dcac840ecc468b0b5bb158d3d131f0c607029409266702"
    sha256 cellar: :any,                 arm64_ventura:  "d7f4470ddcd149ca17f9df55efc216c7b50744ddaa8c15ed927cf3e619fa5183"
    sha256 cellar: :any,                 arm64_monterey: "2aedcc4915f55fb3ce1bb60e473b9cc0ac130f51bdc2998e7da44d90f66948d2"
    sha256 cellar: :any,                 sonoma:         "01b24dc6e02e93c31bce18e53503408f40c355de92c0b3d007e6396dc94cbee6"
    sha256 cellar: :any,                 ventura:        "3dae4f88099a330fafd0864a1e45196187e2383a939928c3e89cd2bde5626257"
    sha256 cellar: :any,                 monterey:       "d4d7a7a96547426688ae799b3f81527f2620ad2407f183e15f0bf407d9d5c377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca19e80f6115c942465ee2564c44527ff5b466a39fddc36a179cbc3825934802"
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
