class Modsecurity < Formula
  desc "Libmodsecurity is one component of the ModSecurity v3 project"
  homepage "https://github.com/SpiderLabs/ModSecurity"
  url "https://github.com/SpiderLabs/ModSecurity/releases/download/v3.0.10/modsecurity-v3.0.10.tar.gz"
  sha256 "d5d459f7c2e57a69a405f3222d8e285de419a594b0ea8829058709962227ead0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "74daa8baf155a510aacaddebd4167c30cf505cafe362ec6a20d32275643fef10"
    sha256 cellar: :any,                 arm64_monterey: "a64c4749d95e04cdc07464c83552825bde05f70386fa0c2fb4e43d39afeccb5f"
    sha256 cellar: :any,                 arm64_big_sur:  "a43c52792a2b656c82996afefb8248b77cf26a950d00ab4376e1d0084ce3f2a4"
    sha256 cellar: :any,                 ventura:        "cb90defa1cdf7988987e463594ff42d56294233c4e15a4dd8fdaf4e1cbf1bbad"
    sha256 cellar: :any,                 monterey:       "4ba84464d43d3eda060ce94864ea6fe6cafaf6ffa365295fce20d6673285ecf3"
    sha256 cellar: :any,                 big_sur:        "ecf3b809af81c2a7c8dc5a3067a1b0d9da346d0455567f52c0642a2de23a1a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "444547afdca675abe0c154f9aaa1bdc5fa7b384f95c24e78e3d032062754cd5a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "geoip"
  depends_on "libmaxminddb"
  depends_on "lua"
  depends_on "pcre2"
  depends_on "yajl"

  uses_from_macos "curl", since: :monterey
  uses_from_macos "libxml2"

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    libxml2 = "#{MacOS.sdk_path_if_needed}/usr"
    libxml2 = Formula["libxml2"].opt_prefix if OS.linux?

    args = [
      "--disable-debug-logs",
      "--disable-doxygen-html",
      "--disable-examples",
      "--with-libxml=#{libxml2}",
      "--with-lua=#{Formula["lua"].opt_prefix}",
      "--with-pcre2=#{Formula["pcre2"].opt_prefix}",
      "--with-yajl=#{Formula["yajl"].opt_prefix}",
    ]

    system "./configure", *args, *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/modsec-rules-check \"SecAuditEngine RelevantOnly\"")
    assert_match("Test ok", output)
  end
end
