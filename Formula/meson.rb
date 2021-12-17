class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.60.2/meson-0.60.2.tar.gz"
  sha256 "64e6968565bf1b8152f4f9d6ca8154efb9e14caa9aabf7b22e71e6c5d053e921"
  license "Apache-2.0"
  revision 1
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "54b3564424cbf3e194a1ade78e6c2fb0d499b83a7f2ac82ebcca40ff29daa0a0"
  end

  depends_on "ninja"
  depends_on "python@3.10"

  # Fix GNOME install_dir handling.
  # Remove with 0.60.3.
  patch do
    url "https://github.com/mesonbuild/meson/commit/3074bb14a14c00aeb350bf592acf635a93b52d9a.patch?full_index=1"
    sha256 "2829c181b5a3a152b0d0d3b20ea3dccda04b22c362473dfa636b7e2ec2f7ffff"
  end

  def install
    python3 = Formula["python@3.10"].opt_bin/"python3"
    system python3, *Language::Python.setup_install_args(prefix)

    # Make the bottles uniform. This also ensures meson checks `HOMEBREW_PREFIX`
    # for fulfilling dependencies rather than just `/usr/local`.
    mesonbuild = prefix/Language::Python.site_packages(python3)/"mesonbuild"
    inreplace_files = %w[
      coredata.py
      dependencies/boost.py
      dependencies/cuda.py
      dependencies/qt.py
      mesonlib/universal.py
      modules/python.py
    ].map { |f| mesonbuild/f }

    # Passing `build.stable?` ensures a failed `inreplace` won't fail HEAD installs.
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX, build.stable?
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system bin/"meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
