class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.59.0/meson-0.59.0.tar.gz"
  sha256 "e376c298df64b643dfe01eccb2d7b6f1e02e95aa38c19f19d120d129612ce476"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7e7b7fdf0ad240d831ca738eb871a40adaa8e0eb6bf329301cd83e38bbe9adc1"
    sha256 cellar: :any_skip_relocation, big_sur:       "8db517f017c88b49517c8d90f3d98e50de8447a946122ac2e79cc08dfda530b5"
    sha256 cellar: :any_skip_relocation, catalina:      "8db517f017c88b49517c8d90f3d98e50de8447a946122ac2e79cc08dfda530b5"
    sha256 cellar: :any_skip_relocation, mojave:        "8db517f017c88b49517c8d90f3d98e50de8447a946122ac2e79cc08dfda530b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e7b7fdf0ad240d831ca738eb871a40adaa8e0eb6bf329301cd83e38bbe9adc1"
  end

  depends_on "ninja"
  depends_on "python@3.9"

  def install
    version = Language::Python.major_minor_version Formula["python@3.9"].bin/"python3"
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system Formula["python@3.9"].bin/"python3", *Language::Python.setup_install_args(prefix)

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
