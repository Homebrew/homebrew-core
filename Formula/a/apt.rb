class Apt < Formula
  desc "Advanced Package Tool"
  homepage "https://wiki.debian.org/Apt"
  # Using git tarball as Debian does not retain old versions at deb.debian.org
  url "https://salsa.debian.org/apt-team/apt/-/archive/3.3.8/apt-3.3.8.tar.bz2"
  sha256 "c61e7ae1117d6be89464a78e1f70bde5f181d086c50fe1df1f79b8f9ac12eb3d"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://deb.debian.org/debian/pool/main/a/apt/"
    regex(/href=.*?apt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "1175277f626d826824563e30beefb59811a0bc680f529c100a2511585ef6d98f"
    sha256 arm64_linux:  "a38552f18278f1dc10f6e1e16f3b9377898bdbd8f88798849eae5452e6f72cdb"
    sha256 x86_64_linux: "f4c938beacdbf3f2e082c903f29552a86ac4b3346bb17a514e7d34be8c67f8d5"
  end

  keg_only "it conflicts with system apt"

  depends_on "cmake" => :build
  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "libxslt" => :build
  depends_on "po4a" => :build
  depends_on "w3m" => :build

  # Upstream plans for replacing Berkeley DB:
  # - https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1119193
  # - https://salsa.debian.org/apt-team/apt/-/merge_requests/489
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL-3.0 restrictions
  depends_on "bzip2"
  depends_on "dpkg"
  depends_on :linux
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "perl"
  depends_on "sequoia-sqv"
  depends_on "systemd"
  depends_on "xxhash"
  depends_on "xz"
  depends_on "zlib-ng-compat"
  depends_on "zstd"

  fails_with :gcc do
    version "12"
    cause "Requires C++23 support for `std::ranges::contains`"
  end

  resource "triehash" do
    url "https://github.com/julian-klode/triehash/archive/refs/tags/v0.3.tar.gz"
    sha256 "289a0966c02c2008cd263d3913a8e3c84c97b8ded3e08373d63a382c71d2199c"

    livecheck do
      url :url
      regex(/^v?(\d+(?:\.\d+)+)$/i)
    end
  end

  deny_network_access!

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.prepend_path "PATH", buildpath/"bin"

    resource("triehash").stage do
      (buildpath/"bin").install "triehash.pl" => "triehash"
    end

    berkeley_db_include = dep("berkeley-db").opt_include
    system "cmake", "-S", ".", "-B", "build",
                    "-DDPKG_DATADIR=#{formula_opt_libexec("dpkg")}/share/dpkg",
                    "-DDOCBOOK_XSL=#{formula_opt_prefix("docbook-xsl")}/docbook-xsl",
                    "-DBERKELEY_INCLUDE_DIRS=#{berkeley_db_include}",
                    "-DWITH_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgetc/"apt.conf.d").mkpath
  end

  test do
    assert_match "Listing", shell_output("#{bin}/apt list 2>&1")
    assert_match "Dir \"/\"", shell_output("#{bin}/apt-config dump")
  end
end
