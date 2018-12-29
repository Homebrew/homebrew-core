class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.49.0/meson-0.49.0.tar.gz"
  sha256 "fb0395c4ac208eab381cd1a20571584bdbba176eb562a7efa9cb17cace0e1551"
  revision 1
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5495fa3f380734c399280310c720c954d3a651a17145557b415274ba68ab0af" => :mojave
    sha256 "ab131d1287dbf5563bfe409de5d4464f82659ce85061799564170dfe6f85178b" => :high_sierra
    sha256 "ab131d1287dbf5563bfe409de5d4464f82659ce85061799564170dfe6f85178b" => :sierra
  end

  depends_on "ninja"
  depends_on "python"

  # Fix issues with Qt, remove in 0.49.1
  # https://github.com/mesonbuild/meson/pull/4652
  patch do
    url "https://github.com/mesonbuild/meson/commit/c1e416ff.patch?full_index=1"
    sha256 "3be708cc65d2b6e54d01e64031c83b06abad2eca1c658b97b2230d1aa7d1062b"
  end

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
