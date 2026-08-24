class Libcdio < Formula
  desc "Compact Disc Input and Control Library"
  homepage "https://savannah.gnu.org/projects/libcdio/"
  url "https://github.com/libcdio/libcdio/releases/download/2.4.0/libcdio-2.4.0.tar.gz"
  sha256 "bf7cde63762bb12db7755c395c441e49406fde7e1d9f9a9be7e3b940b1f405d7"
  license "GPL-3.0-or-later"
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "63b83d23d846413492957f23dbcc2067fd6b6cc390070589f504d29536185021"
    sha256 cellar: :any, arm64_sequoia: "0ab9db75edc2dcd8cbfe0fe99c7b70adfc20571c4fc6a99aa11887e88ff13247"
    sha256 cellar: :any, arm64_sonoma:  "545c01fb50d7308a4b5bcef3c2fbee2a302d45b217a55cdb8dd1815dcb08843b"
    sha256 cellar: :any, sonoma:        "da83f108303962a0c07b718381e8389fa88d89b2610b5617ff021385faf6f394"
    sha256 cellar: :any, arm64_linux:   "559111e87970d4bb864e1116c826d9e7e2de91d498bbec43cb14ded2a5ba6796"
    sha256 cellar: :any, x86_64_linux:  "4498c0794e22062f7a526ad7432abf09e3a1fd9c2892aa62af53ed747846801c"
  end

  depends_on "pkgconf" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cd-info -v", 1)
  end
end
