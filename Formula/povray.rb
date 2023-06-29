class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.10.tar.gz"
  sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"
  license "AGPL-3.0-or-later"
  revision 7
  head "https://github.com/POV-Ray/povray.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    sha256 arm64_ventura:  "92ce02da2ae0eea57acb586fc919264b4918f7696405a7c6a8b66c4d920a0c7d"
    sha256 arm64_monterey: "aace1bf57f9bba4f26b714a494d388c6b98efd8970130f72774bb658616760ac"
    sha256 arm64_big_sur:  "3869e58d10d1caa2c94dcfd31c45e01e4b7ea71f99bba45992edd56904732c66"
    sha256 ventura:        "09afcc0eea5c0093285c6c50b5bc24353d20e2835f9f762df69f6d34d66c2d06"
    sha256 monterey:       "bb416493be670f03c49257472d316dc361822fada5826b932a02778d6072d0e2"
    sha256 big_sur:        "017544d66e4526704f389e2d264fa05681e33a0b4a9091dd0d6b6e6d195516a0"
    sha256 x86_64_linux:   "d35eb08021e4827ebba4d68c8d64107e90c32103fe32445de6bb0fa8b0de9b17"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

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
    scenes = Dir["#{share}/povray-3.7/scenes/advanced/teapot/*.pov"]
    assert !scenes.empty?, "Failed to find test scenes."
    scenes.each do |scene|
      system "#{share}/povray-3.7/scripts/render_scene.sh", ".", scene
    end
  end
end
