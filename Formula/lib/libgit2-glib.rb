class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://gitlab.gnome.org/GNOME/libgit2-glib"
  url "https://gitlab.gnome.org/GNOME/libgit2-glib/-/archive/v1.2.0/libgit2-glib-v1.2.0.tar.bz2"
  sha256 "421ac5c99e02c5b6235842e60eb7f9fa8dc580d2500fb1eb521ced8a22de9f29"
  license "LGPL-2.1-only"
  revision 1
  head "https://gitlab.gnome.org/GNOME/libgit2-glib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "9f946eede73c439ba10b05863c75c95edf7b04798b1e02c9d633ecf4781da32a"
    sha256 cellar: :any, arm64_sonoma:   "b95571e3e781efaa5f25a35570b70e7bd6cdcb1ddc259fbde15ea4ada4f4fdff"
    sha256 cellar: :any, arm64_ventura:  "7daba9e7e88b07c51dda615784f2e2e1fa11afbb9056dae95ec499bd0d56f737"
    sha256 cellar: :any, arm64_monterey: "362cfd852233d5a5947668911d2ac1520efed4775867c846679ef46ac91cb2c4"
    sha256 cellar: :any, sonoma:         "0549acee239da6d75b165ab7ebb864e70d339e96f970aa226654f7291e96bd8b"
    sha256 cellar: :any, ventura:        "844b931e1e3a82557e8fb8578b59e3a9e3c68420f942453a6499b650565ea6e8"
    sha256 cellar: :any, monterey:       "4a10eec01bea9e0fe0689b0a68911a13b12bae857b20206968123600b8a65adc"
    sha256               x86_64_linux:   "2b0f2753501ccd392198453629c4b290085e906728722af8f4e7522b114d7e32"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgit2@1.7"

  on_macos do
    depends_on "gettext"
  end

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
