class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://gitlab.gnome.org/GNOME/libgit2-glib"
  url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/archive/v1.2.1/libgit2-glib-v1.2.1.tar.bz2"
  sha256 "e15d98cf15cd9dc8aaae8a11ab44f51f3a0da3ad4ace80ede3831c934e1897d7"
  license "LGPL-2.1-only"
  head "https://gitlab.gnome.org/GNOME/libgit2-glib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "003f423a05d4a12f3e922b31e4e0f782751fdc35415ca42224cf6b339bdd28cb"
    sha256 cellar: :any, arm64_sequoia: "627c83def62678ab65731f86805ddc7bc12150d9d9ef53d8e15e6f5d49d237ed"
    sha256 cellar: :any, arm64_sonoma:  "2c356b58f8c0b00b4297e63722a0cca3e66566388a0afb1c3ce6b09c9343760b"
    sha256 cellar: :any, arm64_ventura: "e4b0903ca8b7080e5b2b18e30154d4f4d77fdc1fa78d1851401e0814f79f0cc9"
    sha256 cellar: :any, sonoma:        "a08109665a8ba8789748dfdf2ba84b08bc8013e7cd59eaae676bd06d80382b9a"
    sha256 cellar: :any, ventura:       "56b91a0d776f8c8fe39cf89e02553075d64df05217b809291d7c0d34f6a29302"
    sha256               arm64_linux:   "7cccaa7fcd0b32e36b3b6ada4cd7a289664b16e6575d5369b70741c464613040"
    sha256               x86_64_linux:  "9720677ca97a144f7d851f9068e8fe5304968f6bc627f8af4a6fac30705f6029"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgit2"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    system "meson", "setup", "build", "-Dpython=false", "-Dvapi=true", *std_meson_args
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
