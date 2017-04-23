class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.40.0/meson-0.40.0.tar.gz"
  sha256 "3332e92a6a7c53b9011544fb19c86cb0e3ec13857ef70401dc7d7f45d0a0a95f"
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
