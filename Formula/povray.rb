class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.10.tar.gz"
  sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"
  license "AGPL-3.0-or-later"
  revision 6
  head "https://github.com/POV-Ray/povray.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    sha256 arm64_ventura:  "580b81f2246772e8bcee4402506b085331e310c5780e38d0053d9ca1cbe4ddb2"
    sha256 arm64_monterey: "cd9ad4f32d9b05d6490bf7bfb6e0d5c5a77847a1ce43b086d8f23892e9f91558"
    sha256 arm64_big_sur:  "6427029529eb67d2eaa6bd5eed17bf95d8de02bff764a4af273f67d93b3c9f2b"
    sha256 ventura:        "ad4e5cbe3f11205c442b34df05bc1f5b6452d33ae6abc5ca064c4900c542f4ef"
    sha256 monterey:       "b204744035f30bd52812f2558b8c399a4c1a9c31b2967c314356eb00db28fd1a"
    sha256 big_sur:        "4c77233181beeac23703e64f56bf36a41a928bad75560bb362f6110f0cc4785f"
    sha256 x86_64_linux:   "264eecfc2ef535f739f72846dc1881958079ab46c42812a0e0ab433a7ac20e72"
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
