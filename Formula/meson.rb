class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.49.0/meson-0.49.0.tar.gz"
  sha256 "fb0395c4ac208eab381cd1a20571584bdbba176eb562a7efa9cb17cace0e1551"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaa73c91e4b3bb0b7e8e6364b84be2ce1330ea40b01694a98ffee272764b7b32" => :mojave
    sha256 "2cc846989fb920de5ed7c26be7e1136991fdb36575d37a6ce3af09e892bd7ed2" => :high_sierra
    sha256 "2cc846989fb920de5ed7c26be7e1136991fdb36575d37a6ce3af09e892bd7ed2" => :sierra
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
