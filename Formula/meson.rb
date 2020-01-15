class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.53.0/meson-0.53.0.tar.gz"
  sha256 "035e75993ab6fa6c9ebf902b835c64cf397a763eb8e65c9bb6e1cc9730a9d3f6"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33069076c8bb41ba5387e6965afeb80df1e28ed60dae4d14e4a47de4ef26b55c" => :catalina
    sha256 "33069076c8bb41ba5387e6965afeb80df1e28ed60dae4d14e4a47de4ef26b55c" => :mojave
    sha256 "33069076c8bb41ba5387e6965afeb80df1e28ed60dae4d14e4a47de4ef26b55c" => :high_sierra
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
