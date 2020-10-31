class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.56.0/meson-0.56.0.tar.gz"
  sha256 "291dd38ff1cd55fcfca8fc985181dd39be0d3e5826e5f0013bf867be40117213"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af2dea8641edb4252110e4927fa8431c4210ca9ec2ef9de987904e2ede30ef9b" => :catalina
    sha256 "edc3be95c93716e90152208040c0632bb38ab5c4a73e631745776e2481d6e24c" => :mojave
    sha256 "b76267e45d86281640a0b4fa03a42c4a1864acfd851e113faa0c036e2f4c7e6e" => :high_sierra
  end

  depends_on "ninja"
  depends_on "python@3.9"

  def install
    version = Language::Python.major_minor_version Formula["python@3.9"].bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
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
