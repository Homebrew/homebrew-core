class Frankenphp < Formula
  desc "Modern PHP app server"
  homepage "https://frankenphp.dev"
  url "https://github.com/dunglas/frankenphp/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "593417b182730d776e4117a7400ef1975a51bbc2e30bb4c4761d7a59fd5206d6"
  license "MIT"
  head "https://github.com/dunglas/frankenphp.git", branch: "main"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "composer" => :build
  depends_on "go" => :build
  depends_on "gzip" => :build
  depends_on "libtool" => :build
  depends_on "make" => :build
  depends_on "php" => :build
  depends_on "pkg-config" => :build
  depends_on "xz" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "bzip2" => :build
  uses_from_macos "curl" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "unzip" => :build

  def install
    ENV["FRANKENPHP_VERSION"] = version.to_s

    # Disable UPX compression to speed up build
    ENV["NO_COMPRESS"] = "1"

    # "spc doctor" is useless in this case and fails because it needs the Brew binary
    inreplace "build-static.sh", "./bin/spc doctor --auto-fix", ""

    system "./build-static.sh"
    bin.install Dir.glob("dist/frankenphp-*").first => "frankenphp"
  end

  test do
    system bin/"frankenphp", "version"

    (testpath/"hello.php").write("<?php echo 'Hello, world!';")
    assert_match "Hello, world!", shell_output("#{bin}/frankenphp php-cli hello.php")
  end
end
