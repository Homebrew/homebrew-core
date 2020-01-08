class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.52.1/meson-0.52.1.tar.gz"
  sha256 "0c277472e49950a5537e3de3e60c57b80dbf425788470a1a8ed27446128fc035"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b10cf0e32247a056c6c2f6ef7a4897d1677784dc8acb41bb2ce67423dddaa983" => :catalina
    sha256 "b10cf0e32247a056c6c2f6ef7a4897d1677784dc8acb41bb2ce67423dddaa983" => :mojave
    sha256 "b10cf0e32247a056c6c2f6ef7a4897d1677784dc8acb41bb2ce67423dddaa983" => :high_sierra
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
