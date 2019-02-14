class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.49.2/meson-0.49.2.tar.gz"
  sha256 "ef9f14326ec1e30d3ba1a26df0f92826ede5a79255ad723af78a2691c37109fd"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c88c187b083768e2be90f86415706f7d7d9f18ad517b08dfbf7263c2df2e9fe0" => :mojave
    sha256 "c88c187b083768e2be90f86415706f7d7d9f18ad517b08dfbf7263c2df2e9fe0" => :high_sierra
    sha256 "2b6cc4e4a70bb1a048fd5fb742ba429222ef4c0292b5978fac2b8d0ff38e3f4e" => :sierra
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
