class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.33.0/meson-0.33.0.tar.gz"
  sha256 "c3a5bfe863b3a041469bccee9ad5b4fd7c8d451d633381fe40102731cec5b294"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fa4f650263a65f2aa8c753cc6d1433b764807b13b95bf138058d179034eed91" => :el_capitan
    sha256 "7d3c678431fdfe0f497717933e241d908156f6e2dadfe59fbd1913a3eaa0e492" => :yosemite
    sha256 "3949c3b75216caa1001cdbcccf9ae2bf805251515875e7262e32b0f27ba5f88e" => :mavericks
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
