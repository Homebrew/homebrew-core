class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.41.1/meson-0.41.1.tar.gz"
  sha256 "3d160b0514ff3d25f0a47975c6f70fd82b76c589876d10413efc5e01df43e0c2"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b4c5ef8c006ce9c6745c2bbf53ddebcd48399a848dd261d869ee4c7b8ed9297" => :sierra
    sha256 "aeab62933900c640c1182ba921fe5785ae1851372ba7890ddb5e3434a9221b46" => :el_capitan
    sha256 "aeab62933900c640c1182ba921fe5785ae1851372ba7890ddb5e3434a9221b46" => :yosemite
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
