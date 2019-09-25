class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.51.2/meson-0.51.2.tar.gz"
  sha256 "23688f0fc90be623d98e80e1defeea92bbb7103bf9336a5f5b9865d36e892d76"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
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
