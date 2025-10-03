class Imgp < Formula
  include Language::Python::Shebang

  desc "High-performance CLI batch image resizer & rotator"
  homepage "https://github.com/jarun/imgp"
  url "https://github.com/jarun/imgp/archive/refs/tags/v2.9.tar.gz"
  sha256 "4cc3dcbe669ff6b97641ce0c6c332e63934d829a0700fd87171d5be5b1b89305"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b0ee7ffcfa799ee0c2157c291db758e12bc1d7ad6a29fa7403fcbe3f7d29394"
  end

  depends_on "pillow"
  depends_on "python@3.13"

  def install
    rewrite_shebang detected_python_shebang, "imgp"
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "auto-completion/bash/imgp-completion.bash" => "imgp"
    fish_completion.install "auto-completion/fish/imgp.fish"
    zsh_completion.install "auto-completion/zsh/_imgp"
  end

  test do
    cp test_fixtures("test.png"), "test.png"
    system bin/"imgp", "-x", "50", "test.png"
    assert_path_exists testpath/"test_IMGP.png"

    assert_match version.to_s, shell_output("#{bin}/imgp --help 2>&1")
  end
end
