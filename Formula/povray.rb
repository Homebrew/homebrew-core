class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.10.tar.gz"
  sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"
  license "AGPL-3.0-or-later"
  revision 4
  head "https://github.com/POV-Ray/povray.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    sha256 arm64_ventura:  "bfc8165d9d4f40422baada6a3e0f13e3640bbfe18ffadb63ad9889323093a8bf"
    sha256 arm64_monterey: "2032ae90f229fbe6f3fdcae66d4767295232de2cfe7c56f9f04b832de5a8fbfb"
    sha256 arm64_big_sur:  "d614487df79e96385724fee64473eff2e13a38c148157877ae4652a4c37ea661"
    sha256 ventura:        "3e680ffe8a72884cc7e43f8ebf7296c320513f7c98bce5cef353b3a71471a753"
    sha256 monterey:       "9ae1df8c6db5a0658a02a5bd8f08fd8cb8be5300b152233d71f2ef45e368ecdf"
    sha256 big_sur:        "0f961aae4c0d5e972b73f1ff37912d4fc4a99b2a9583e9e83f7071c90d513088"
    sha256 catalina:       "4f319b19fa285b2b9b134c610e77f9be10af29517a58bdbd5e2187410852f743"
    sha256 x86_64_linux:   "924422864eab357aece24e2e5968461f9dea4e79e346819523301feebf9f144a"
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
