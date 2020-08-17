class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.55.1/meson-0.55.1.tar.gz"
  sha256 "3b5741f884e04928bdfa1947467ff06afa6c98e623c25cef75adf71ca39ce080"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2f25cb6f38a6e9d8dad19da2420d8efb1641e9ef2e2e5fa8f473e8707ba8bde" => :catalina
    sha256 "a2f25cb6f38a6e9d8dad19da2420d8efb1641e9ef2e2e5fa8f473e8707ba8bde" => :mojave
    sha256 "a2f25cb6f38a6e9d8dad19da2420d8efb1641e9ef2e2e5fa8f473e8707ba8bde" => :high_sierra
  end

  depends_on "ninja"
  depends_on "python@3.8"

  def install
    version = Language::Python.major_minor_version Formula["python@3.8"].bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system Formula["python@3.8"].bin/"python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
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
