class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.52.0/meson-0.52.0.tar.gz"
  sha256 "d60f75f0dedcc4fd249dbc7519d6f3ce6df490033d276ef1cf27453ef4938d32"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8df30b9960a09372a5695bb8a6c2275ecd42337d668e6334c846652cc0803e20" => :catalina
    sha256 "8df30b9960a09372a5695bb8a6c2275ecd42337d668e6334c846652cc0803e20" => :mojave
    sha256 "8df30b9960a09372a5695bb8a6c2275ecd42337d668e6334c846652cc0803e20" => :high_sierra
  end

  depends_on "ninja"
  depends_on "python"

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
