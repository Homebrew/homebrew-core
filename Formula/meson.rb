class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.31.0/meson-0.31.0.tar.gz"
  sha256 "803d7aa99329c5439ef971c1dcaa39de12d9208f82f0ed029e3e8f9c13ef93f0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a807e6daf90cf6dab8768510e38d3f13a3ee99acd1f82f0f196b80dd9a62a89" => :el_capitan
    sha256 "f2cab3cfa82e715f9d19ff996338028ba6240d11fa5254eae7d0da59d12c8969" => :yosemite
    sha256 "f30d5c84f5dde05536a487108b7be4031a4f9b3dadb55e3bdb8a91dda9dc48d7" => :mavericks
  end

  depends_on :python3
  depends_on "ninja"

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib+"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
      system "#{bin}/meson.py", ".."
      assert File.exist?(testpath/"build/build.ninja")
    end
  end
end
