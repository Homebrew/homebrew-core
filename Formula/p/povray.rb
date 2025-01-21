class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/refs/tags/v3.7.0.10.tar.gz"
  sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"
  license "AGPL-3.0-or-later"
  revision 12
  head "https://github.com/POV-Ray/povray.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    sha256 arm64_sequoia: "bd7eccb30230aa3859c02c26b426dbfca63f0eb93b48564c1e4c31fa537b5a5a"
    sha256 arm64_sonoma:  "a17b7182bafcbacd4e6d46c226a533b60a0d40c333f62f831140d159a6933197"
    sha256 arm64_ventura: "55c3b7c6cf5fa1cf23e32d0991c5471a3a773565b659a84d7c5cb70074c449b2"
    sha256 sonoma:        "d42d43ab4cbd13d0f11a537ecc770c0f55e0ac915e6ec67367fb705f68264b9f"
    sha256 ventura:       "4ede95b6f50cf5df055bf3f549a771e94b5f0703cbf12731af92944e5b841bb9"
    sha256 x86_64_linux:  "81ffc7a05cecfd52d9db6e1148c995f1a1265a559f036659834c4acfe24d1691"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    args = %W[
      COMPILED_BY=homebrew
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-openexr=#{Formula["openexr"].opt_prefix}
      --without-libsdl
      --without-x
    ]

    # Adjust some scripts to search for `etc` in HOMEBREW_PREFIX.
    %w[allanim allscene portfolio].each do |script|
      inreplace "unix/scripts/#{script}.sh",
                /^DEFAULT_DIR=.*$/, "DEFAULT_DIR=#{HOMEBREW_PREFIX}"
    end

    cd "unix" do
      system "./prebuild.sh"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    # Condensed version of `share/povray-3.7/scripts/allscene.sh` that only
    # renders variants of the famous Utah teapot as a quick smoke test.
    scenes = share.glob("povray-3.7/scenes/advanced/teapot/*.pov")
    refute_empty scenes, "Failed to find test scenes."
    scenes.each do |scene|
      system share/"povray-3.7/scripts/render_scene.sh", ".", scene
    end
  end
end
