class GuileFibers < Formula
  desc "Concurrent ML-like concurrency for Guile"
  homepage "https://codeberg.org/guile/fibers"
  url "https://codeberg.org/guile/fibers/archive/v2.0.0.tar.gz"
  sha256 "5cf63d8afbafe94b51fc94ccaf24f1643438dabfdd8f5fa83ff89cb0b2650b13"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "20d846a468f1f21cbb74fc73062e403d60df50b81fd6d9acec164051441f7393"
    sha256 arm64_tahoe:       "a198ed5e9b09491ffd641bc6d77a21b6b257487a8f3712576ddd931bd854207e"
    sha256 arm64_sequoia:     "68fa201fb2342fafa93418def0246e248796809a69e22f89dc58bbfbc0c4bae2"
    sha256 arm64_linux:       "7dd25c6c684782a47c3982a2fde58a773cccde47c0d816f2f4f0ce6417053b44"
    sha256 x86_64_linux:      "17dfc1fde0574fd509b3af79fb61e6b14b47e4d847a880580c3b725f31fbb6e6"
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

  deny_network_access!

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
