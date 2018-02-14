class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.16.2/pycairo-1.16.2.tar.gz"
  sha256 "49a3cf8737c009852e97289d43e952bf228d8df53a7ddb840d4deeb4d0cc1ea7"

  bottle do
    cellar :any
    sha256 "8f0e738c337db39228c54613d92628f38f9ae484c44091b7009712db5c1c0976" => :high_sierra
    sha256 "cd33e199107a61afb3602bce56a568b1a18178907387384967628097b0502a88" => :sierra
    sha256 "0280c974f1035f80ba3dfe1ee41003f0be0fbfe63e1ec78bbd45a580254c9d7c" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python3"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python3", "-c", "import cairo; print(cairo.version)"
  end
end
