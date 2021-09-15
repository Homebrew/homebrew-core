class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/30/c5/255b6ae9c180eccb4a2e453ac3760327683d73ef4530a516a06d3de256de/fonttools-4.27.0.zip"
  sha256 "22ca101453fbc41fc5e34749402e41bdc41064b66daea80440cc12f501a45ad7"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cc85522258d99d31b6d0c9d59dc50787b3e2989d0445dcacf44459f35e641d68"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d332952a5149c4b692b9652abebd21ee98fe5b0633385c303a12f88ae81d707"
    sha256 cellar: :any_skip_relocation, catalina:      "8d332952a5149c4b692b9652abebd21ee98fe5b0633385c303a12f88ae81d707"
    sha256 cellar: :any_skip_relocation, mojave:        "8d332952a5149c4b692b9652abebd21ee98fe5b0633385c303a12f88ae81d707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25ab6e2fe63b4c83b7857246c3084a6d3dcc0ce4b12562a4adab3d656df43821"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
