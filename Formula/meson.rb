class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.32.0/meson-0.32.0.tar.gz"
  sha256 "2e8c06136da01607364cbcd8a719f0f60441a9a4c5f1426e88a3c6a8444331ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "cffbceed57dc20e5d4efe53461d78279fe977953184ea52d1e50c13b27c2639f" => :el_capitan
    sha256 "f93a3ab8c9065ae44a10f0e34b9d39b67dd798a6f19fb20212c1cde056d37457" => :yosemite
    sha256 "c4404af3c4a994e8701695d5a327fb35b3d8fac88c977a44e6eed5d8fd7d9323" => :mavericks
  end

  depends_on :python3
  depends_on "ninja"

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib+"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
      system "#{bin}/meson.py", ".."
      assert File.exist?(testpath/"build/build.ninja")
    end
  end
end
