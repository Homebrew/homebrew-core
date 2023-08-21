class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://gitlab.gnome.org/GNOME/libgit2-glib"
  license "LGPL-2.1-only"
  revision 1
  head "https://gitlab.gnome.org/GNOME/libgit2-glib.git", branch: "master"

  stable do
    url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/archive/v1.1.0/libgit2-glib-v1.1.0.tar.bz2"
    sha256 "6cbbf43eda241cc8602fc22ccd05bbc4355d9873634bc12576346e6b22321f03"

    # Add commit signing API. Needed for dependent `gitg`.
    # Remove with `stable` block on next release.
    patch do
      url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/commit/7f36e18f41e0b28b35c85fe8bf11d844a0001305.diff"
      sha256 "e5a07c6bbd05b88f1d52107167d7db52f43abfd0b367645cc75b72acb623d9ff"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "dc78ea81c37b8e8977ef2d6469166e37937c06238cee7b5e46c3856b459aed8a"
    sha256 cellar: :any, arm64_monterey: "e3ff1e622801cc996caff77b2ca138e69764fceab2f4dfccb7a35f4dd622643f"
    sha256 cellar: :any, arm64_big_sur:  "3a250cd16c5583e345b2eba049765b4b27c67207a2a0373c741710e7a139105a"
    sha256 cellar: :any, ventura:        "d416576872b58f6b67fe70d94f2af9a0174da2f44c4cb95ddddc8f628de78fc1"
    sha256 cellar: :any, monterey:       "731ae37b595af558aa4fe4a0d18cc43916405d73b6eecaa0045c42b414e6e735"
    sha256 cellar: :any, big_sur:        "227b09aa6272fc3e4aba191c7d3144c09d0888a229291a717ba293251ca193c0"
    sha256               x86_64_linux:   "ef2aaf12a607c505944c2d752f31b8c1120993a9c499bfc93b0f71353975e55a"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgit2"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    system "meson", "setup", "build", *std_meson_args,
                                      "-Dpython=false",
                                      "-Dvapi=true"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    libexec.install (buildpath/"build/examples").children
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end
