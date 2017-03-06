class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.39.0/meson-0.39.0.tar.gz"
  sha256 "e582b040038d6ae7c44e64eda05bc24e0a9328629a82c3e4c2bfb983eade7592"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80d59f7ee1afa370685a4755f8bf22c88d9a4a6685142a2898d4a595c96820df" => :sierra
    sha256 "80d59f7ee1afa370685a4755f8bf22c88d9a4a6685142a2898d4a595c96820df" => :el_capitan
    sha256 "80d59f7ee1afa370685a4755f8bf22c88d9a4a6685142a2898d4a595c96820df" => :yosemite
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
