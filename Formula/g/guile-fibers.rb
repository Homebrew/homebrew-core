class GuileFibers < Formula
  desc "Concurrent ML-like concurrency for Guile"
  homepage "https://codeberg.org/guile/fibers"
  url "https://codeberg.org/guile/fibers/archive/v1.4.3.tar.gz"
  sha256 "fd055e9cee7ec11f7d9a6009e5387c002e99beb9fa9d2da3eab1b4da92b5be91"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d7820b2b6dbae6c3db7b2d4491faa37bc2acc0678d9c6166da50cf3d7fa8d32e"
    sha256 arm64_sequoia: "296b5b70e909c339aa4e415bbb577976b45e14f1c04fe065ef888ba59d7f2d25"
    sha256 arm64_sonoma:  "91386472691afd79272cc8ab3b4531caedcc265dc50e31b6a6dee0bfd7a60c1c"
    sha256 sonoma:        "539cc161f1176fb5912e5d2f8ba01319d74a74145b1b0fc99b5bf29cc112b7e6"
    sha256 arm64_linux:   "d0d723de5bacf5f31c01c24e8ba3709538bd9eca797e152a7dce35ec23f9b0e8"
    sha256 x86_64_linux:  "0dbce87520b4f7f50ef10b2b4aed5f4607d2ca5e1bec164b3e8e46bcb17a6d6c"
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
