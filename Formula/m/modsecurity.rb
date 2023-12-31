class Modsecurity < Formula
  desc "Libmodsecurity is one component of the ModSecurity v3 project"
  homepage "https://github.com/SpiderLabs/ModSecurity"
  url "https://github.com/SpiderLabs/ModSecurity/releases/download/v3.0.11/modsecurity-v3.0.11.tar.gz"
  sha256 "070f46c779d30785b95eb1316b46e2e4e6f90fd94a96aaca4bd54cd94738b692"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e266b488284dd9b9d8aab365b810c17606a23fbf5f86b6701b69385a13437894"
    sha256 cellar: :any,                 arm64_ventura:  "b8bde9a47b7654a849392967f8ec11725f35b639084c72a026abbb83e1cc6637"
    sha256 cellar: :any,                 arm64_monterey: "17ef83d3a930642bcfc0e879a1a58397dfa8018dc76deb41e92f541f13358f82"
    sha256 cellar: :any,                 sonoma:         "d4fd30d5fa2d6d405e30e512cb08d0f6c361bf5b2ac05b11d3adbdca80ef5e07"
    sha256 cellar: :any,                 ventura:        "c3a5263cc77cf9ebd0222f46dbd7276e210412d7e3a18b6ac71b29562cc74ec1"
    sha256 cellar: :any,                 monterey:       "bb033e230355f7167d8d2399c779612dd7b0eabd9c4f2a54278d24e68196f15e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5d93203ccd8dc1006de010d2a8bc6a4c41485041377828f354ec0b137d4f0e6"
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
  # Issue ref: https://github.com/SpiderLabs/ModSecurity/issues/3023
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
