class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.44.1/meson-0.44.1.tar.gz"
  sha256 "2ea1a721574adb23160b6481191bcc1173f374e02b0ff3bb0ae85d988d97e4fa"
  revision 1
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6a6dc8ccc57cbd2cf2c3644f55ffebd0cc12d19234173237f2968adf5db827a" => :high_sierra
    sha256 "d6a6dc8ccc57cbd2cf2c3644f55ffebd0cc12d19234173237f2968adf5db827a" => :sierra
    sha256 "d6a6dc8ccc57cbd2cf2c3644f55ffebd0cc12d19234173237f2968adf5db827a" => :el_capitan
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
