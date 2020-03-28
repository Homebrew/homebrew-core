class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.54.0/meson-0.54.0.tar.gz"
  sha256 "dde5726d778112acbd4a67bb3633ab2ee75d33d1e879a6283a7b4a44c3363c27"
  revision 1
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "674b211a427f97e52b1a517fc606de85b43fc3ebd7c7387abe9a7aafb5b5172c" => :catalina
    sha256 "674b211a427f97e52b1a517fc606de85b43fc3ebd7c7387abe9a7aafb5b5172c" => :mojave
    sha256 "674b211a427f97e52b1a517fc606de85b43fc3ebd7c7387abe9a7aafb5b5172c" => :high_sierra
  end

  depends_on "ninja"
  depends_on "python@3.8"

  def install
    version = Language::Python.major_minor_version Formula["python@3.8"].bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system Formula["python@3.8"].bin/"python3", *Language::Python.setup_install_args(prefix)

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
