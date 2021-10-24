class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.60.0/meson-0.60.0.tar.gz"
  sha256 "080d68b685e9a0d9c9bb475457e097b49e1d1a6f750abc971428a8d2e1b12d47"
  license "Apache-2.0"
  revision 1
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e888116367f7771eb01f9c18d6c32b7a55972ab365d513d9a2e8d1e5cc6c5ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e888116367f7771eb01f9c18d6c32b7a55972ab365d513d9a2e8d1e5cc6c5ea"
    sha256 cellar: :any_skip_relocation, monterey:       "d9773b4862b104210d3c6683ea3f2752ea4d7493f6dd3b45c1a030bfff8f5d81"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9773b4862b104210d3c6683ea3f2752ea4d7493f6dd3b45c1a030bfff8f5d81"
    sha256 cellar: :any_skip_relocation, catalina:       "d9773b4862b104210d3c6683ea3f2752ea4d7493f6dd3b45c1a030bfff8f5d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e888116367f7771eb01f9c18d6c32b7a55972ab365d513d9a2e8d1e5cc6c5ea"
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

    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX
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
