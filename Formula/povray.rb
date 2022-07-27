class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.10.tar.gz"
  sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"
  license "AGPL-3.0-or-later"
  revision 3
  head "https://github.com/POV-Ray/povray.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    sha256 arm64_monterey: "50c1033aa599a0c313e1321ac13556c7010149e55ee8e250f6cd91bba1b90d11"
    sha256 arm64_big_sur:  "b81e5f00128b2b215a73cd4dacd27829faadb4aea63c10139736e851f9858fe6"
    sha256 monterey:       "91a6fa846d5220e1b2f7e20ece98f52cf9ee34d301c339cb07f90bc09c4dfd15"
    sha256 big_sur:        "497cfaba5d266ce6e1d5906fa8724418817b5faff66f521bf434cf6fa33fa5b4"
    sha256 catalina:       "82bf8090b26e6f470a6c7c76a050ca53ca5c2ae8c0445b172050f01a29cfc070"
    sha256 x86_64_linux:   "8acd14c9e9e02e4965712979981063184361285aff59695b2a779dad49e022ea"
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
