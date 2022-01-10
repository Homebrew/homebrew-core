class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.61.0/meson-0.61.0.tar.gz"
  sha256 "ea9f33246b1f23f02e90a50e75e0f41e526f6dabf0c24f3e00e27a3f5abdc35c"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b51016f9a5f261da9baa0f30e3e36f9eddcf147494970f3f1baa68ac8b83e666"
  end

  depends_on "ninja"
  depends_on "python@3.10"

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
