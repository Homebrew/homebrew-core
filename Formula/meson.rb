class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.49.1/meson-0.49.1.tar.gz"
  sha256 "e90c8ee46109d3b9d9a12c76c65811d4a7f7e18503f780eb301866e43d9052cb"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8015e3f47873ed46e930e3819a059b7b1624951bae2fcc0ba58de05d25966fe" => :mojave
    sha256 "602c437f746f1eab0705836647d2cb6d09d004743945b92db69f87a52c50caac" => :high_sierra
    sha256 "602c437f746f1eab0705836647d2cb6d09d004743945b92db69f87a52c50caac" => :sierra
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
