class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.37.1/meson-0.37.1.tar.gz"
  sha256 "72516e25eaf9efd67fe8262ccba05e1e84731cc139101fcda7794aed9f68f55a"
  revision 1
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76d6400d5d9bd18e1459087386f31b31877caead4f13bee7e80d92aa2ded63a5" => :sierra
    sha256 "5e08f512288133c5b041856a26c06e50fe8146222e884ce4ebc3943dc9d19ec1" => :el_capitan
    sha256 "5e08f512288133c5b041856a26c06e50fe8146222e884ce4ebc3943dc9d19ec1" => :yosemite
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
