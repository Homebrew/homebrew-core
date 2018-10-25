class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.48.1/meson-0.48.1.tar.gz"
  sha256 "425d12edbb81498314926afa93a3eb2fca4ca6929cbe0f8abeb6ab45d1d9fa8f"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35d1fe7d9de728c09ff0401dd1cb2c1505172e13cb8ccdf4e0c8db3d74bad8d5" => :mojave
    sha256 "edf31f9dabaf6623d739b9a3cf7282e718d76aa65360098855fedd6f88d6c1f8" => :high_sierra
    sha256 "edf31f9dabaf6623d739b9a3cf7282e718d76aa65360098855fedd6f88d6c1f8" => :sierra
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
