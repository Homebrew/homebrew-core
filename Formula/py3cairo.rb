class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.16.2/pycairo-1.16.2.tar.gz"
  sha256 "49a3cf8737c009852e97289d43e952bf228d8df53a7ddb840d4deeb4d0cc1ea7"

  bottle do
    cellar :any
    sha256 "3f2d751e183b9865bed16988c4c25f055c62cc38b992b092df0620e6538b1c35" => :high_sierra
    sha256 "992880d46bdef80622f05d60fbe5e9f1e7ca76fa2686b62d597e14f3ff0f3b7b" => :sierra
    sha256 "b7027c7c2bd4ddcfcc5b30ab278c2bbe358da01b87afadf6c03907f5dfd36018" => :el_capitan
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
