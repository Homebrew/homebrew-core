class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.54.2/meson-0.54.2.tar.gz"
  sha256 "a7716eeae8f8dff002e4147642589ab6496ff839e4376a5aed761f83c1fa0455"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b67fe8a3c5d7b093af1958f65f26cb99cc7e95065d1da833817a420607aec0cd" => :catalina
    sha256 "b67fe8a3c5d7b093af1958f65f26cb99cc7e95065d1da833817a420607aec0cd" => :mojave
    sha256 "b67fe8a3c5d7b093af1958f65f26cb99cc7e95065d1da833817a420607aec0cd" => :high_sierra
  end

  depends_on "ninja"
  depends_on "python@3.8"

  def install
    Language::Python.rewrite_python_shebang(Formula["python@3.8"].opt_bin/"python3")

    version = Language::Python.major_minor_version Formula["python@3.8"].bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system Formula["python@3.8"].bin/"python3", *Language::Python.setup_install_args(prefix)

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
