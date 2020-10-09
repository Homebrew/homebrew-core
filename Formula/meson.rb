class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.55.3/meson-0.55.3.tar.gz"
  sha256 "6bed2a25a128bbabe97cf40f63165ebe800e4fcb46db8ab7ef5c2b5789f092a5"
  license "Apache-2.0"
  revision 1
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f41289199e9e6db06679eaca7fa5ee34bb7547158b4bfa939097802a3af1cd52" => :catalina
    sha256 "3669e734c120df0826befa19bedd8bc0fee79bea743780c41ecc6ec9b7d5b7fb" => :mojave
    sha256 "922d395b86fc7274ce2d12cd4bec95e2a7248919573a0861bfb0069607d82b21" => :high_sierra
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
