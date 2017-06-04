class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.40.1/meson-0.40.1.tar.gz"
  sha256 "890ce46e713ea0d061f8203c99fa7d38645354a62e4c207c38ade18db852cbf5"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "13270ccf68ae00cfb4696e490de8b5faaa93bc5210c8da3d2f3970314846b511" => :sierra
    sha256 "09428e77c670aff11773a9dede0b60d03844f447cccfe8a42caa926e7f9be097" => :el_capitan
    sha256 "09428e77c670aff11773a9dede0b60d03844f447cccfe8a42caa926e7f9be097" => :yosemite
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
