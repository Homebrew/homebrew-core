class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  head "https://github.com/mesonbuild/meson.git"

  stable do
    url "https://github.com/mesonbuild/meson/releases/download/0.50.1/meson-0.50.1.tar.gz"
    sha256 "f68f56d60c80a77df8fc08fa1016bc5831605d4717b622c96212573271e14ecc"

    # Fixes support for Xcode 11.
    # Backported from https://github.com/mesonbuild/meson/commit/b28e76f6bf6898a7de01f5dd103d5ad7c54bea45
    # Should be in the next release.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/bd45b828dc74b33b35a89dc02dd1f556064d227f/meson/xcode_11.patch"
      sha256 "7b03f81036478d234d94aa8731d7248007408e56917b07d083f1c4db9bb48c8b"
    end
  end

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
