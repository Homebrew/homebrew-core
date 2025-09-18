class Apt < Formula
  desc "Advanced Package Tool"
  homepage "https://wiki.debian.org/Apt"
  # Using git tarball as Debian does not retain old versions at deb.debian.org
  url "https://salsa.debian.org/apt-team/apt/-/archive/3.1.5/apt-3.1.5.tar.bz2"
  sha256 "fde3de2503b3a4cea43a37ed105f1fbe37189820a93dad00d50a78feb7159daf"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/a/apt/"
    regex(/href=.*?apt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "0407b085f73c1c3de98529dce90ce54923ea04d898eba88c0c25ffe52926d6da"
    sha256 x86_64_linux: "def540cd29d93087f6feb7186cfb11630b5c3d208cd086cb9c388eb212a7ee74"
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

  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL-3.0 restrictions
  depends_on "bzip2"
  depends_on "dpkg"
  depends_on :linux
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "perl"
  depends_on "sequoia-sqv"
  depends_on "systemd"
  depends_on "xxhash"
  depends_on "xz"
  depends_on "zlib"
  depends_on "zstd"

  resource "triehash" do
    url "https://github.com/julian-klode/triehash/archive/refs/tags/v0.3.tar.gz"
    sha256 "289a0966c02c2008cd263d3913a8e3c84c97b8ded3e08373d63a382c71d2199c"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.prepend_path "PATH", buildpath/"bin"

    resource("triehash").stage do
      (buildpath/"bin").install "triehash.pl" => "triehash"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DDPKG_DATADIR=#{Formula["dpkg"].opt_libexec}/share/dpkg",
                    "-DDOCBOOK_XSL=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl",
                    "-DBERKELEY_INCLUDE_DIRS=#{Formula["berkeley-db@5"].opt_include}",
                    "-DWITH_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgetc/"apt.conf.d").mkpath
  end

  test do
    assert_match "apt does not have a stable CLI interface. Use with caution in scripts",
                 shell_output("#{bin}/apt list 2>&1")
  end
end
