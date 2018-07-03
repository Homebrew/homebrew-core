class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.47.0/meson-0.47.0.tar.gz"
  sha256 "1bd360a58c28039cdb3b8ce909764e90a58481deb79396227ba4081af377f009"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1695d2cffa2207a5c0b99999bacb239822593e50550ec3ed99ca1d5f1ab257b1" => :high_sierra
    sha256 "1695d2cffa2207a5c0b99999bacb239822593e50550ec3ed99ca1d5f1ab257b1" => :sierra
    sha256 "1695d2cffa2207a5c0b99999bacb239822593e50550ec3ed99ca1d5f1ab257b1" => :el_capitan
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
