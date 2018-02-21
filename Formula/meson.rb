class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.44.1/meson-0.44.1.tar.gz"
  sha256 "2ea1a721574adb23160b6481191bcc1173f374e02b0ff3bb0ae85d988d97e4fa"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "24f5cc0a99ef512d796b7b5b2a4cfcb2a414f685bfd645f90bdd0e2091ee271c" => :high_sierra
    sha256 "24f5cc0a99ef512d796b7b5b2a4cfcb2a414f685bfd645f90bdd0e2091ee271c" => :sierra
    sha256 "24f5cc0a99ef512d796b7b5b2a4cfcb2a414f685bfd645f90bdd0e2091ee271c" => :el_capitan
  end

  depends_on "python3"
  depends_on "ninja"

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
