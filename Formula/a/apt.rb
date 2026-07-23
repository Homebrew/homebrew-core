class Apt < Formula
  desc "Advanced Package Tool"
  homepage "https://wiki.debian.org/Apt"
  # Using git tarball as Debian does not retain old versions at deb.debian.org
  url "https://salsa.debian.org/apt-team/apt/-/archive/3.3.1/apt-3.3.1.tar.bz2"
  sha256 "0891dd9f0b89d87479993cb608df62b1e676d42c0846cc34cbca58d1e4135e63"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/a/apt/"
    regex(/href=.*?apt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "f1b606134a6570c7feaf07310e1a400e6b5f3a654b5b3f859922f15e57a3b5b3"
    sha256 x86_64_linux: "4b09194baf22b7e22a50f7b6c3e60766ef4789cff940199ad0ddd359574af68b"
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
  depends_on "openssl@3"
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

  # Backport upstream fix: hashes.cc uses std::span without including <span>,
  # which fails to build with newer libstdc++ that no longer pulls it in transitively
  patch do
    url "https://salsa.debian.org/apt-team/apt/-/commit/a13b5091addd4f065b426297686c861bffc7527a.patch"
    sha256 "231f7aef8f3f559f7289370746b16c798851c9adb0f245305bd0d19a235ab33e"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    ENV.prepend_path "PATH", buildpath/"bin"

    resource("triehash").stage do
      (buildpath/"bin").install "triehash.pl" => "triehash"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DDPKG_DATADIR=#{formula_opt_libexec("dpkg")}/share/dpkg",
                    "-DDOCBOOK_XSL=#{formula_opt_prefix("docbook-xsl")}/docbook-xsl",
                    "-DBERKELEY_INCLUDE_DIRS=#{formula_opt_include("berkeley-db@5")}",
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
