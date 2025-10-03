class Mimic < Formula
  desc "Lightweight text-to-speech engine based on CMU Flite"
  homepage "https://github.com/MycroftAI/mimic1"
  url "https://github.com/MycroftAI/mimic1/archive/refs/tags/1.3.0.1.tar.gz"
  sha256 "9041f5c7d3720899c90c890ada179c92c3b542b90bb655c247e4a4835df79249"
  # The `:cannot_represent` is for:
  # * Sun Microsystems, Inc. license (e.g. src/speech/g72x.c)
  # * BSD license with 2 clauses but not matching BSD-2-Clause (e.g. src/speech/rateconv.c)
  license all_of: ["MIT-Festival", "BSD-2-Clause", "BSD-3-Clause", "Spencer-86", "Apache-2.0", :cannot_represent]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "c5308faf93176da28184e555f4e6978817d59676b85b5382e6fd7fffb7611bad"
    sha256 arm64_sequoia:  "809c72a67bc515dc1ae83a7c03bf27c9a8bf9d38422aff57d65a58ae27a0bb1e"
    sha256 arm64_sonoma:   "27c12540e94a1f80ccfca3bd15f93a305f84e4c2233253df530dd3d7b1211140"
    sha256 arm64_ventura:  "05a0ae1e6862667edb0311db845d536bc98085e57793620e28f82a013bf58ff9"
    sha256 arm64_monterey: "d5e9edd6ea60a7c799c8d88e35f981dce913d950874ce44fa9805bb7c91c5e32"
    sha256 arm64_big_sur:  "72107347e7fd6f6ca1af6808fe3ea5b428e3dee2f733743a0d44cd9b9e67d492"
    sha256 sonoma:         "1c990348da2905a15589f09b2bb76e4229604fa9c6c8585b2ef4906dbc5620ab"
    sha256 ventura:        "dee98adb3a5b5349d702a7ec8c781046d8ef54d143765d9c35b7e83055d3e9de"
    sha256 monterey:       "b5b3fbdb47926a507b67c517346e66e1b3deba2622f915eb66409c601fe2718b"
    sha256 big_sur:        "ef5067be11a74cc8cd63e266a775ece9ebcf59c9995b630f9717d7333dbdd924"
    sha256 catalina:       "72b346f8eefbbc70abc0a67bc72265b3bec7f99e53b18418ad6835df52518f1e"
    sha256 arm64_linux:    "26e6f55397cb24207058e26f48ce78d837269e3063f295987eb12bf7a778159d"
    sha256 x86_64_linux:   "027d95ecca63daf3f9c20419da6630b9a6a2d00e92dbdccbbc5d1747e0aca4d4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "pcre2"

  on_macos do
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--enable-shared",
                          "--enable-static",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mimic", "-t", "Hello, Homebrew!", "test.wav"
    assert_path_exists testpath/"test.wav"
  end
end
