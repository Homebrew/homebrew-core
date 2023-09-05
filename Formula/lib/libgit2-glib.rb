class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://gitlab.gnome.org/GNOME/libgit2-glib"
  url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/archive/v1.2.0/libgit2-glib-v1.2.0.tar.bz2"
  sha256 "421ac5c99e02c5b6235842e60eb7f9fa8dc580d2500fb1eb521ced8a22de9f29"
  license "LGPL-2.1-only"
  head "https://gitlab.gnome.org/GNOME/libgit2-glib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "1fe5fe74645a85743b063f8b3b87a3a95d1f08baaf939eea3a8399fb7d11f4d2"
    sha256 cellar: :any, arm64_monterey: "0acba9ffc1f7f5a9b78d3dba685564b9abb1f2ab7fafc33c952a0f38ed18c665"
    sha256 cellar: :any, arm64_big_sur:  "d25c6019431293c7c4536c88c78dfddfa7d6daa58865a0d751d5e063cc3d3bfb"
    sha256 cellar: :any, ventura:        "7821187b992687679d7c7a0ff2d26a13c4cf9b0acebc8c64a80227e05f3a002f"
    sha256 cellar: :any, monterey:       "9088ebccecd0b04312da6a6fc457600c085d7279f8c7e797eae315cc94c12110"
    sha256 cellar: :any, big_sur:        "bafc615584caf3b11a104e4f2e83416b80ab442ec7ee82d0993cd3a4647c5232"
    sha256               x86_64_linux:   "29a96ea2997da39fc923ee2c90b4f7cc604cd34e2e3a648ccf9c6e937f397177"
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
