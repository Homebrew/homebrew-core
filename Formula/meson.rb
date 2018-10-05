class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.48.0/meson-0.48.0.tar.gz"
  sha256 "982937ba5b380abe13f3a0c4dff944dd19d08b72870e3b039f5037c91f82835f"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fa2d1353bc85a7e4e9a5bbc7f025ae2212022fced5321ac4d3e95ae54dd008f" => :mojave
    sha256 "fe029b8e1c5191d71c3c1c214a9b9530d82d8d992516731afbbe4a29de6f510e" => :high_sierra
    sha256 "fe029b8e1c5191d71c3c1c214a9b9530d82d8d992516731afbbe4a29de6f510e" => :sierra
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
