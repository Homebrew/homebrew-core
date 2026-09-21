class Imgp < Formula
  include Language::Python::Shebang

  desc "High-performance CLI batch image resizer & rotator"
  homepage "https://github.com/jarun/imgp"
  url "https://github.com/jarun/imgp/archive/refs/tags/v3.0.tar.gz"
  sha256 "8d11fc1969ec908b996e04d2d266137fa167221152d2a9e4197308393b41bf03"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "25a228f3fc9be51282ff36029fda1322123215aaa46edede5163a1a31b8156bf"
  end

  depends_on "pillow"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pillow"

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
