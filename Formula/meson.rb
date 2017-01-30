class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.38.0/meson-0.38.0.tar.gz"
  sha256 "407f0faf4e9ed3340a2146e044c1c6c60a5795b4ec83605bdab1623de3effc82"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1567e3d9c0b8c50366b1b46e60f483eb50d9182decccc76f46eeee2514217d39" => :sierra
    sha256 "d8f33e19765689fdba82c26b529f5d5230abc6bab4ee9b94d334445a367af3d5" => :el_capitan
    sha256 "d8f33e19765689fdba82c26b529f5d5230abc6bab4ee9b94d334445a367af3d5" => :yosemite
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
