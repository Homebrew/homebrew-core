class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.45.0/meson-0.45.0.tar.gz"
  sha256 "3455abbc30a3fbd9cc8abb6d5fcdc42ce618665b95ac2c3ad7792a4a6ba47ce4"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "776f32acaba8c700e5c426a47f7f246d453bffcc610b354b22cf374538939379" => :high_sierra
    sha256 "776f32acaba8c700e5c426a47f7f246d453bffcc610b354b22cf374538939379" => :sierra
    sha256 "776f32acaba8c700e5c426a47f7f246d453bffcc610b354b22cf374538939379" => :el_capitan
  end

  depends_on "python"
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
