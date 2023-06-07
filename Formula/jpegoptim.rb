class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/v1.5.4.tar.gz"
  sha256 "8fc7537f722d533ea8b45966ab80c83e3342d088d5a690fdadfb05b7c9cba47f"
  license "GPL-3.0-or-later"
  head "https://github.com/tjko/jpegoptim.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a59ad10a7855793ec0304923f7cb4ac099e478fcd278fa4817027726ab2e88e"
    sha256 cellar: :any,                 arm64_monterey: "891c58a30d122e2a17b38130129fca967998ed7e3221baca20b5befe7de985fe"
    sha256 cellar: :any,                 arm64_big_sur:  "d20ccf6a6e5399b5c718a8043d320f1b849472d7e7719511c7a4a7474104785c"
    sha256 cellar: :any,                 ventura:        "07f09cf165e1ac2fcbdbe73bb74903e2d12bf59a73ef79cb2f37c8c53e165cf6"
    sha256 cellar: :any,                 monterey:       "9f8d1aa50a57dbd3d7fdb4228db7bb54830bcd4e76bd36c2eca499a27a2ff55e"
    sha256 cellar: :any,                 big_sur:        "5787ef4770350cbdc7b04f1289a6a647e613937ffd8b1ec7e51816b4780731d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dee5355d6b7055067741fca37a200d1c20514e06119309b72cee617b6821cea4"
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
