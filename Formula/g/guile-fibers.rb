class GuileFibers < Formula
  desc "Concurrent ML-like concurrency for Guile"
  homepage "https://github.com/wingo/fibers"
  url "https://github.com/wingo/fibers/releases/download/v1.3.1/fibers-1.3.1.tar.gz"
  sha256 "a5e1a9c49c0efe7ac6f355662041430d4b64e59baa538d2b8fb5ef7528d81dbf"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "cc7bd001428bf0240b533ae88c465ebaa7ed4eeaf48ef2862d1540462e830912"
    sha256 arm64_sequoia: "b0ffb1a8e973c4c824afef59cc42b36f02f402ac562157be5eeefe4fd5f35552"
    sha256 arm64_sonoma:  "aecafccfe6ae02c9d8aa3cec97cc91017995e5af3b6844f92f6a895289385828"
    sha256 arm64_ventura: "c4efa5f223403ee3bb438ef926dca0775564e5756e6ce9c0e754698542c7b90a"
    sha256 sonoma:        "e314596a82b167bcd6548de44fd5d415987b257d8b46e2640a5924cc3c741530"
    sha256 ventura:       "b1fc7b219a7f68cded6c9786daedae1450870fcf5feccdd04cb38ce3ad4bc5b2"
    sha256 arm64_linux:   "d65a242acbf399e5666386ab6cf904c76389046dad4781aec73567acc72c4d26"
    sha256 x86_64_linux:  "d94c75d9e2acfbf27ba8387935d757398f54287c38654ae9a51169934f54c096"
  end

  depends_on "guile"
  depends_on "libevent"

  on_macos do
    depends_on "bdw-gc"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
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
