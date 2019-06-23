class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.51.0/meson-0.51.0.tar.gz"
  sha256 "2f75fdf6d586d3595c03a07afcd0eaae11f68dd33fea5906a434d22a409ed63f"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ca178fb13cb8a3152875fb98c572e7a1f436ab97e408667479fcccb28cd9a815" => :mojave
    sha256 "ca178fb13cb8a3152875fb98c572e7a1f436ab97e408667479fcccb28cd9a815" => :high_sierra
    sha256 "ef9198b9fb068aa7f805fcb7a2de846c71390c495d4cbc07c6d9c50366811441" => :sierra
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
