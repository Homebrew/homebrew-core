class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://github.com/folkertvanheusden/HTTPing"
  url "https://github.com/folkertvanheusden/HTTPing/archive/refs/tags/v2.9.tar.gz"
  sha256 "37da3c89b917611d2ff81e2f6c9e9de39d160ef0ca2cb6ffec0bebcb9b45ef5d"
  license "GPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "f23584840d9dcfe8b4b7feefd73ac8fab046f59d67289ac23f3c85669dcdd2f3"
    sha256 cellar: :any,                 arm64_ventura:  "3141fe1d3df5213ea50d737dcbe5a22d19470b1b71bb5224cc31ab8cae5b1c7e"
    sha256 cellar: :any,                 arm64_monterey: "94510b3f65c4e5e09f50416ed42dc3cea4919d423b44fb535abf33c931852fff"
    sha256 cellar: :any,                 arm64_big_sur:  "a8986b877e0394d14426ddf81cdd2434bdaea19d77b5a89fde3b15abbf7a52f6"
    sha256 cellar: :any,                 sonoma:         "e4105852026458d7ded9139afb2f37fd0dac185b1a267cbe957e73cd49092bde"
    sha256 cellar: :any,                 ventura:        "fbd0751a4589fc47844450fbdf7ed2addd0209e5fe5cd1e9fcf67a0fd5e9f97a"
    sha256 cellar: :any,                 monterey:       "b81b8e64adb726690636e16e1b321a105b7ea74c2976334c555ee2057735b193"
    sha256 cellar: :any,                 big_sur:        "cb7cf7e658c4d92d83fcbaa36779c4ed3b5d03b64cd764a77c68b83be85997f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94b00c89e3f72041ad7e5aee324783437ad76f99c1b5bfdacf858e6aaa4d101d"
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext" # for libintl
  end

  def install
    # Reported upstream, see: https://github.com/folkertvanheusden/HTTPing/issues/4
    inreplace "utils.h", "useconds_t", "unsigned int"
    # Reported upstream, see: https://github.com/folkertvanheusden/HTTPing/issues/7
    inreplace %w[configure Makefile], "lncursesw", "lncurses"
    ENV.append "LDFLAGS", "-lintl" if OS.mac?
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"httping", "-c", "2", "-g", "https://brew.sh/"
  end
end
