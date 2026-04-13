class GuileFibers < Formula
  desc "Concurrent ML-like concurrency for Guile"
  homepage "https://codeberg.org/guile/fibers"
  url "https://codeberg.org/guile/fibers/archive/v1.4.2.tar.gz"
  sha256 "bf61f58fdea48b4b28a9683d4493fcbced2ce2d7d98a7c1b1234353161de1ece"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "1bee6c686302cf6e3a14b3b95d69abd6ecf3eba1c6e874cd7e45b6ac1750382d"
    sha256 arm64_sequoia: "f7c3157cf53a382ab389b6ff17efec684da6336db120267d10008fb910629c73"
    sha256 arm64_sonoma:  "a52d3e21900ea493acf2a685bd7483d284b5fd49ab2fcc27afebc703e22a077c"
    sha256 sonoma:        "dd0553292a041b1bde78aaa47e1b349fc0641905599ccc76ba062d1af581dce2"
    sha256 arm64_linux:   "84965397128aa9d36b064f36a293e5fbed0990ea647a9f9a1ff8339bbbc3eaa5"
    sha256 x86_64_linux:  "92cbd38c301b82939872a754a7e44d0b03ed7873b0731f131ec8c3ab634a7cd4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "guile"
  depends_on "libevent"

  on_macos do
    depends_on "bdw-gc"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = share/"guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = lib/"guile/3.0/site-ccache"

    (testpath/"test-fibers.scm").write <<~SCHEME
      (use-modules (fibers))
      (display "fibers loaded\\n")
    SCHEME

    output = shell_output("guile test-fibers.scm")
    assert_match "fibers loaded", output
  end
end
