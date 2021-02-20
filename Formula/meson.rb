class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.57.0/meson-0.57.0.tar.gz"
  sha256 "7ccb75fe1a4d404bcab86e72678abc7f75793401aa9054f881a4eb3cb990f5d9"
  license "Apache-2.0"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f63a333f46c40ab18a91f87aa8287a6e05cb7ce878b951b8df114389a46c6527"
    sha256 cellar: :any_skip_relocation, big_sur:       "42584d82af0b26172a6589bee5fbf02a0dba67d907c14c55d840080c8ce52b91"
    sha256 cellar: :any_skip_relocation, catalina:      "f1c06b574606c2752bd1800e8e5fa907a8dc25251fe50fc5b6c0a30eb6195574"
    sha256 cellar: :any_skip_relocation, mojave:        "58634cf0a251a75e89d9f5baf74bc7587ac4a2eb52bd52214f49c49ad75ff5b5"
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
