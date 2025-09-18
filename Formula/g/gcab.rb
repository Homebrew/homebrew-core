class Gcab < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/gcab/1.6/gcab-1.6.tar.xz"
  sha256 "2f0c9615577c4126909e251f9de0626c3ee7a152376c15b5544df10fc87e560b"
  license "LGPL-2.1-or-later"

  # We use a common regex because gcab doesn't use GNOME's "even-numbered minor
  # is stable" version scheme.
  livecheck do
    url :stable
    regex(/gcab[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "dbdb82143e59cafc2357e57d67c491fdabc97ad442e7ea64db68a3394ed4f3f9"
    sha256 arm64_sequoia:  "e6e1d52d928e85cb2fbbea1220fb224c61dae65fe1525959ae6fb61f7f77b013"
    sha256 arm64_sonoma:   "7191f605413c808ef98d36eb37021fc8b038692ace3b8429b2d1b7e1c49b941e"
    sha256 arm64_ventura:  "1bba0eb507e8f2d7b64ad8c1a28c12dc74a785747a4683baa60437c2a4b015a6"
    sha256 arm64_monterey: "6bb87009bd9a5f53529273af07389d8cf4a3aae0c55a9dd51c617b598d5f7fc6"
    sha256 arm64_big_sur:  "abeac675d359f49d72372bb3e829a4abae65dddb5e2e92087cf0db14596b8040"
    sha256 sonoma:         "ecdb571082d959ac47d5eb8cdebec587e0fb564dda216e2431c8f5730b229d69"
    sha256 ventura:        "d8cdcdfd05260f7ea32808b2b58f6711b2d1288bdd57b003dae112c99bc67a7d"
    sha256 monterey:       "3ccbb8269e8171382a3e9a3de7805a96f7c64e402eed4a0a277eb57978485c22"
    sha256 big_sur:        "2f7491f5f92549e9f9d23e42091f4dc24e36a921284a540a79665c6073e663f4"
    sha256 arm64_linux:    "c41cdb0840e595d8cca48e6a741036dbe4c646970d45f1f04a8c87d84915b6e2"
    sha256 x86_64_linux:   "88ce4ede127ca2477d6939b9053f9474bb8c23c3cee2cf53c6a4f003d2b8ea63"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", "-Ddocs=false", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gcab", "--version"
  end
end
