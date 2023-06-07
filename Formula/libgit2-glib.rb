class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/archive/v1.1.0/libgit2-glib-v1.1.0.tar.bz2"
  sha256 "6cbbf43eda241cc8602fc22ccd05bbc4355d9873634bc12576346e6b22321f03"
  license "LGPL-2.1-only"
  head "https://github.com/GNOME/libgit2-glib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "cd5ce302746b146fbcae23c34a4962cadf2aa6167872281c60c2dbd0c933e596"
    sha256 cellar: :any, arm64_monterey: "5869d595f0b03d283cb6f787c7af59d3327eedf6bf611ec406a490866080bbb5"
    sha256 cellar: :any, arm64_big_sur:  "5c31a305f66afe9e3c458262bdc4f41c925c35e731291103dae3c22ebb0f09d2"
    sha256 cellar: :any, ventura:        "aec5c85cf10c6dfedf37abeffe5e5a0a7302e399ef2a6d8171e8d1534cd7925d"
    sha256 cellar: :any, monterey:       "f2df1953378a0ff1019120b487e4af95f11336ac73f83d3aed783f6f00c24fa9"
    sha256 cellar: :any, big_sur:        "533f498e8be1e520fea8d11fbf035e827e8dab689d986b00469836f1cb0977ba"
    sha256               x86_64_linux:   "ce8ce4014e3755d3d814a7893a46d456f9ad6ccb06a4bbda964a8250ef3b4fff"
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
    mkdir "build" do
      ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
      system "meson", *std_meson_args,
                      "-Dpython=false",
                      "-Dvapi=true",
                      ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
      libexec.install Dir["examples/*"]
    end
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end
