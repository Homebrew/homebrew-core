class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.57.1/meson-0.57.1.tar.gz"
  sha256 "72e1c782ba9bda204f4a1ed57f98d027d7b6eb9414c723eebbd6ec7f1955c8a6"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "27cfeb861038b0c1928e2301bc3caf6dc4ed26bc7b353d796cd546b97099894b"
    sha256 cellar: :any_skip_relocation, big_sur:       "f798ac28df81a00f561310c0586952a41634536953e31e8b313aadf54de7a975"
    sha256 cellar: :any_skip_relocation, catalina:      "617a2f8071127e097fe39d2cbeb92fbd2074ed0f38a9883f84e0ddc1449726da"
    sha256 cellar: :any_skip_relocation, mojave:        "eb3e4ffa73b41573c7c09a2ea44deefa4a8bcc512e1e5d0ebcac8d45f0c1bb77"
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
