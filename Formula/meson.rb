class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.40.1/meson-0.40.1.tar.gz"
  sha256 "890ce46e713ea0d061f8203c99fa7d38645354a62e4c207c38ade18db852cbf5"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2c5fb7d1646ce203455fe158fead13150d1c6b792c0b7389744d1c909b190c7" => :sierra
    sha256 "5c6e4b25c5d9464bcda603d78f4be02c425dff7defb202ed53428b668e45b591" => :el_capitan
    sha256 "5c6e4b25c5d9464bcda603d78f4be02c425dff7defb202ed53428b668e45b591" => :yosemite
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
