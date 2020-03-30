class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.54.0/meson-0.54.0.tar.gz"
  sha256 "dde5726d778112acbd4a67bb3633ab2ee75d33d1e879a6283a7b4a44c3363c27"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2855c6300305417e6b709f9f4a197b6b9905255d947dd8263b14443c18a64a6" => :catalina
    sha256 "b2855c6300305417e6b709f9f4a197b6b9905255d947dd8263b14443c18a64a6" => :mojave
    sha256 "b2855c6300305417e6b709f9f4a197b6b9905255d947dd8263b14443c18a64a6" => :high_sierra
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
