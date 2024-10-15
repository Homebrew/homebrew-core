class Decasify < Formula
  desc "Utility for casting strings to title-case according to locale-aware style guides"
  homepage "https://github.com/alerque/decasify"
  url "https://github.com/alerque/decasify/releases/download/v0.7.6/decasify-0.7.6.tar.zst"
  sha256 "299e462cf5a93b5a7da865764ca94729111945349f5fb6e2e79b5bbeff574cd9"
  license "LGPL-3.0-only"

  head do
    url "https://github.com/alerque/decasify.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jq" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "decasify v#{version}", shell_output("#{bin}/decasify --version")
    assert_match "Ben ve İvan", shell_output("#{bin}/decasify -l tr -c title 'ben VE ivan'")
  end
end
