class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://661.org/proj/if/frotz/"
  url "https://gitlab.com/DavidGriffith/frotz/-/archive/2.55/frotz-2.55.tar.bz2"
  sha256 "235a8606aa1e654aa5a5a41b5c7b5ae1e934aab30fb2e2b18e2e35a4eafcd745"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/DavidGriffith/frotz.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "ebf6d67e2019ef8eebb2917725a5d3e981e3638769b42da1e31ac0ba0c54714e"
    sha256 arm64_sequoia: "624ff5dacf69ae3388d0c62040b5a5bd96efb74998e858b0050677fbbf1ef85a"
    sha256 arm64_sonoma:  "b60c0567651c1c60ca575897dd34211f12b4c88d99d7b21e18af209e81c4a44d"
    sha256 arm64_ventura: "3b4a5db73230793ae6dd4a1bad5625f8c680e35d64dd5abc7481cb8c5445ff8b"
    sha256 sonoma:        "a811b517afb5ce7d597cf82a5b04925c302789a502d78363d0cd14755d31896b"
    sha256 ventura:       "8904ff9893d5daa532535d53eebdbd387e569892f0544ae9b1d8995e44906d46"
    sha256 arm64_linux:   "b90ff551b819c8f69602fadfa3aff2f5118d08a5a06f09cecd1e022421cc63fc"
    sha256 x86_64_linux:  "2130987d855f301a70ddf5b8a91aaa3dc348f773da11dcafa62c83339cc96d41"
  end

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libao"
  depends_on "libmodplug"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "ncurses"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  # fix SDL interface build failure
  patch do
    url "https://gitlab.com/DavidGriffith/frotz/-/commit/52be64afc92a6ea0a982ff83205a67cbfb94b619.diff"
    sha256 "d9105caf79c436d98fa80b8091b1dd05de88c8c7f26c2a688133879b7dfa3477"
  end

  def install
    args = %W[PREFIX=#{prefix} MANDIR=#{man} SYSCONFDIR=#{etc} ITALIC=]
    targets = %w[frotz dumb sdl]
    targets.each do |target|
      system "make", target, *args
    end
    ENV.deparallelize # install has race condition
    targets.each do |target|
      system "make", "install_#{target}", *args
    end
  end

  test do
    resource "testdata" do
      url "https://gitlab.com/DavidGriffith/frotz/-/raw/2.53/src/test/etude/etude.z5"
      sha256 "bfa2ef69f2f5ce3796b96f9b073676902e971aedb3ba690b8835bb1fb0daface"
    end

    resource("testdata").stage do
      assert_match "TerpEtude", pipe_output("#{bin}/dfrotz etude.z5", ".")
    end
    assert_match "FROTZ", shell_output("#{bin}/frotz -v").strip
    assert_match "FROTZ", shell_output("#{bin}/sfrotz -v").strip
  end
end
