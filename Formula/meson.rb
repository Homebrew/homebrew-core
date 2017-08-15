class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.42.0/meson-0.42.0.tar.gz"
  sha256 "a74c7387a3dd8171e931bcd948355f7f9529368eae72c3c22a9beef6c2e73498"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1de5889e4725075529173ee2095b49463e37713be96a2ff574ac43f0387dbbc5" => :sierra
    sha256 "1de5889e4725075529173ee2095b49463e37713be96a2ff574ac43f0387dbbc5" => :el_capitan
    sha256 "1de5889e4725075529173ee2095b49463e37713be96a2ff574ac43f0387dbbc5" => :yosemite
  end

  depends_on :python3
  depends_on "ninja"

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<-EOS.undent
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<-EOS.undent
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert File.exist?(testpath/"build/build.ninja")
    end
  end
end
