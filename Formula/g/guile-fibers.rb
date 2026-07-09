class GuileFibers < Formula
  desc "Concurrent ML-like concurrency for Guile"
  homepage "https://codeberg.org/guile/fibers"
  url "https://codeberg.org/guile/fibers/archive/v1.4.3.tar.gz"
  sha256 "abc8b97c9bd595549b908189010e987df9d3685e09208b712f93b8593c97d8a1"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "046edfc6e1a3124110ac07d6e065c8e3af79b083b122402b095e9ac4a264d33c"
    sha256 arm64_sequoia: "8ae867063c720659d652140b18d8e1ed1791ff872159ee449ac0bbc34ddddd87"
    sha256 arm64_sonoma:  "294f46f4d30ddb808bd45e43d051c79e721917ea639ec74fff2ad75f5880f779"
    sha256 sonoma:        "c0d5c2a888e33ecfeffd9a142ad7d1abcd9d1b3251ea1e8675b59c30c8f3fa03"
    sha256 arm64_linux:   "1180e2963d136de828477f527a0206a96e478231b2e0bbcab6570a8372e69353"
    sha256 x86_64_linux:  "c4de3327aed61936c943b83fa5ec24f300c1fd4d23125a1738119ebcde9b773d"
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
