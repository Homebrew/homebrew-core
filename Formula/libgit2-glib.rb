class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.26/libgit2-glib-0.26.4.tar.xz"
  sha256 "97610e42427a0c86ac46b89d5020fb8decb39af47b9dc49f8d078310b4c21e5a"
  revision 2
  head "https://github.com/GNOME/libgit2-glib.git"

  bottle do
    sha256 "b8d58cb52170bbb4a4c387a124db4e2be995bdb2b5ecd4973d73456ebd1f121e" => :mojave
    sha256 "20e1cf8538d46014cf5533510d52c2bb4e98cbfbf6e7a56817fc2e072466200c" => :high_sierra
    sha256 "fc9f0fa31794d7f4c0b67fd68ff0378de0c1f5668b1bc093937ee0c94a7808a8" => :sierra
    sha256 "de784ae7a8154369d33eb13cd6fdca5979e2144cc1561ab4a3c85118b0cbbb20" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgit2"

  def install
    ENV.refurbish_args

    # Fix "ld: unknown option: -Bsymbolic-functions"
    # Reported 2 Apr 2018 https://bugzilla.gnome.org/show_bug.cgi?id=794889
    inreplace "libgit2-glib/meson.build",
              "libgit2_glib_link_args = [ '-Wl,-Bsymbolic-functions' ]",
              "libgit2_glib_link_args = []"

    # Upstream issue from 2 Apr 2018 "libgit2 0.27.0 FTB: ggit-config.c:298:41:
    # error: too few arguments to function call"
    # See https://bugzilla.gnome.org/show_bug.cgi?id=794890
    inreplace "libgit2-glib/ggit-config.c",
              /(\(git_config_level_t\)level,)(\n\s+)(force\);)/,
              "\\1\\2NULL,\\2\\3"

    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      "-Dpython=false",
                      "-Dvapi=true",
                      ".."
      system "ninja"
      system "ninja", "install"
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
