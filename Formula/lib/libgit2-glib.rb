class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://gitlab.gnome.org/GNOME/libgit2-glib"
  url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/archive/v1.2.0/libgit2-glib-v1.2.0.tar.bz2"
  sha256 "421ac5c99e02c5b6235842e60eb7f9fa8dc580d2500fb1eb521ced8a22de9f29"
  license "LGPL-2.1-only"
  revision 4
  head "https://gitlab.gnome.org/GNOME/libgit2-glib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "a0185be8ea66d71580b5eeb82b5417f9563c37ce4b12ddae075395c1347501a4"
    sha256 cellar: :any, arm64_sonoma:  "8569ef1c3abb80763bd596308e7aaf17a51d5f642a3166f9c2231581198b54c0"
    sha256 cellar: :any, arm64_ventura: "c9bbaac6aecfaf70a9ab0005ed14c5e7437efd5d521b97b27275878360a8bf9f"
    sha256 cellar: :any, sonoma:        "3c4ecaa523d209e3e37100f9f91f9e2e5adfd52d15fd78c48a3aaca2135d8f9d"
    sha256 cellar: :any, ventura:       "af630b4af55f3493cffcab70d7ce8e538f608af504ed2f83468de616d0ce8bb6"
    sha256               x86_64_linux:  "1c163d0e7768610588c54ed99bd28109b312933ce5154d826a29a364027e9bdf"
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

  # Support libgit2 1.8+.
  # https://gitlab.gnome.org/GNOME/libgit2-glib/-/merge_requests/40
  patch do
    url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/commit/a76fdf96c3af9ce9d21a3985c4be8a1aa6eea661.diff"
    sha256 "24d32bfc972959c054794917f4043226fc267fafaaf8d8fc7d4128cfa9b5b231"
  end

  # Support libgit2 1.9, upstream pr ref, https://gitlab.gnome.org/GNOME/libgit2-glib/-/merge_requests/46
  patch do
    url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/commit/93685d4297e425af67ac6888d6b66dfbcd4b95c8.diff"
    sha256 "338a51bb04f89a2f53994db206b179e4f20ba69d7aaf38d06ae899dd1c44dab1"
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
