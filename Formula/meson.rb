class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.39.1/meson-0.39.1.tar.gz"
  sha256 "44885ccfef94d3d4afb1053fa6673ed130d3093fc9e9f6624d08161d8a385220"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "acdd8357fbd99faf9ded7f97333cdba7845f78804f06e37dc1056398fa4c3efc" => :sierra
    sha256 "acdd8357fbd99faf9ded7f97333cdba7845f78804f06e37dc1056398fa4c3efc" => :el_capitan
    sha256 "acdd8357fbd99faf9ded7f97333cdba7845f78804f06e37dc1056398fa4c3efc" => :yosemite
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
