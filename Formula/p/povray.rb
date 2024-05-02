class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/refs/tags/v3.7.0.10.tar.gz"
  sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"
  license "AGPL-3.0-or-later"
  revision 10
  head "https://github.com/POV-Ray/povray.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "54b876f530a83175418a5475d4caddb67d196adfa973df16459390e53cac80a2"
    sha256 arm64_ventura:  "f52e87ba1f5ee1d51e9b123d9eb3972037840cde7edd9982cfc5fcdc4009a64e"
    sha256 arm64_monterey: "5e1a101c8ca4290509f9213df0bdb57b5459a43cd8c0de0c18593dc77d706e3b"
    sha256 sonoma:         "b721a8180d2306e06d0d7ff209799c7cfc70f3df6649136dcb8af688338a0cd7"
    sha256 ventura:        "15204901f60eed1990fca78bfa6186d5a5f7c0bcf057dc926a4f30f51bc5e160"
    sha256 monterey:       "b2c5f35dd0a30130cff159e8c59b67e6f48955290a5c5fb70c7d06a5c02dc2c8"
    sha256 x86_64_linux:   "d4e13b8bc59a7e7efacb75ca605d0c7ca3d4676b03a4dd0bf30928fd92e50a24"
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
