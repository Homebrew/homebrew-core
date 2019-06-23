class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.51.0/meson-0.51.0.tar.gz"
  sha256 "2f75fdf6d586d3595c03a07afcd0eaae11f68dd33fea5906a434d22a409ed63f"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fd6bb7dedb95162aca637f4c8c97463b3c14895698120ce15cd24844d39fed0" => :mojave
    sha256 "7fd6bb7dedb95162aca637f4c8c97463b3c14895698120ce15cd24844d39fed0" => :high_sierra
    sha256 "85147f9668c946ab6db2f30016a65e08ad8478f6b1bacf3e5936465c290eef55" => :sierra
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
