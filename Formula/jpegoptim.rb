class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/v1.5.2.tar.gz"
  sha256 "e8701cc85c065e05747a15da72ebb403056ebecaa98e2806cf69cdd443397910"
  license "GPL-3.0-or-later"
  head "https://github.com/tjko/jpegoptim.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "68268b0ca97d6b60edd12be19901f2ba1bac264f20a1b4277621e4c4444d9986"
    sha256 cellar: :any,                 arm64_monterey: "b1b3681cfd782679d5e36877463fe321280580c886fcc6c316390a759692e346"
    sha256 cellar: :any,                 arm64_big_sur:  "23927fe759f3ccfe86eae9c5b4c0cf20795879f0474c671ec3461caedc981a7b"
    sha256 cellar: :any,                 ventura:        "7aa020f78f5ff164bf113973a3013a9305be90e0a203bdae456fc9ba7b05e1d7"
    sha256 cellar: :any,                 monterey:       "e74c7a9c3f3beef103636d913f4886138e3337989aa74c245623275a32c12ee6"
    sha256 cellar: :any,                 big_sur:        "46c3addaa8cf81fb19e1ff0b699e1f0293a41ba3a46fc4f50bd44f0b03bddd51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fe16caf2dd96bbd851cf5b746533da6932998bda6cf505a1ae3014d8eba01cf"
  end

  depends_on "jpeg-turbo"

  def install
    system "./configure", *std_configure_args
    ENV.deparallelize # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end
