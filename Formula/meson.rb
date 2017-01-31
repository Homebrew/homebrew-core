class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.38.0/meson-0.38.0.tar.gz"
  sha256 "407f0faf4e9ed3340a2146e044c1c6c60a5795b4ec83605bdab1623de3effc82"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a3fcd3b8513314b40e3575f89cfad02597989a3d9a375934e417d4ffcacc188" => :sierra
    sha256 "848b398ef8305e9d69d399d5805dc74e333e129a63cbaf352323c5e3b3c0a280" => :el_capitan
    sha256 "848b398ef8305e9d69d399d5805dc74e333e129a63cbaf352323c5e3b3c0a280" => :yosemite
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
