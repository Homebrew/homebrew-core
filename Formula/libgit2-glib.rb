class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/1.0/libgit2-glib-1.0.0.1.tar.xz"
  sha256 "460a5d6936950ca08d2d8518bfc90c12bb187cf6e674de715f7055fc58102b57"
  license "LGPL-2.1-only"
  revision 1
  head "https://github.com/GNOME/libgit2-glib.git", branch: "master"

  livecheck do
    url :stable
    regex(/libgit2-glib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "c86e001454355dad5b14cb809ef3906d0d4a48af97ce9531183cee9adee760d1"
    sha256 cellar: :any, arm64_big_sur:  "c3f021322ea613f5c90264f16003632eb660df8b012dc8640ce020a1d9d04243"
    sha256 cellar: :any, monterey:       "5356f3ba112adc1bb2b2441f18bb53f4322413c3f5046dd9eeb6cee5ef16934b"
    sha256 cellar: :any, big_sur:        "cd447a7ce224d08cb9202e7d664767271e861869a1c045bfbf5577160c3eae3b"
    sha256 cellar: :any, catalina:       "cd9c0702d69739539a1a2fa01add35e372f5eb14a262c7d1692397664c445fcc"
    sha256               x86_64_linux:   "55beee71255b5693f49ff558e4bdf563fd85f9ba87e94551795763e91a507a0b"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
