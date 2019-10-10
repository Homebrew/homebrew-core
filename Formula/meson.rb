class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.52.0/meson-0.52.0.tar.gz"
  sha256 "d60f75f0dedcc4fd249dbc7519d6f3ce6df490033d276ef1cf27453ef4938d32"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "67201f9d5fe703a78db6748d8261bf904008153e5d6899963b8092b9e7d3df15" => :catalina
    sha256 "3b3d59e1d710726301fb379a020323b8f3b630a08b15581527386679be26b5a5" => :mojave
    sha256 "3b3d59e1d710726301fb379a020323b8f3b630a08b15581527386679be26b5a5" => :high_sierra
    sha256 "39a19f4d9b2b03fd6ff1df210cf0de4ae767d027b594046e3394fc1d22eb4d77" => :sierra
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
