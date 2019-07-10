class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.51.1/meson-0.51.1.tar.gz"
  sha256 "f27b7a60f339ba66fe4b8f81f0d1072e090a08eabbd6aa287683b2c2b9dd2d82"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e738539de75c599ffda9eb9abc13634daa470fd3ee84e6f2d58c75c209cf585" => :mojave
    sha256 "9e738539de75c599ffda9eb9abc13634daa470fd3ee84e6f2d58c75c209cf585" => :high_sierra
    sha256 "fe1e6d70ef40f9239304d9ae3412ce19f8150ffbdcb112cd8c8c45422a1ca0b7" => :sierra
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
