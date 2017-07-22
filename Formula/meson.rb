class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "http://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.41.2/meson-0.41.2.tar.gz"
  sha256 "074dd24fd068be0893e2e45bcc35c919d8e12777e9d6a7efdf72d4dc300867ca"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6db65957929eac440dec28556acdf79e8f56876c92e8f0127a28a030a58c8fdf" => :sierra
    sha256 "24b975f8c72963695ceb2f2baf1c0f842b537a45836b254d5098e9bac969f692" => :el_capitan
    sha256 "24b975f8c72963695ceb2f2baf1c0f842b537a45836b254d5098e9bac969f692" => :yosemite
  end

  depends_on :python3
  depends_on "ninja"

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<-EOS.undent
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<-EOS.undent
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert File.exist?(testpath/"build/build.ninja")
    end
  end
end
