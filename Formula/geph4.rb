class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.7.8.tar.gz"
  sha256 "86c30e650dc2636a46370593369a88db9d6347ea217c31776cd20e9b55e39265"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6f68af256709edbef37424b932749ff417da8f4aa9ab434ae74727c8881f01e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b67f65a94ad21ec994c6f520d7c32be3751505b789f2ae945c5df689a8aa2c1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "460b1983d7816a9770d897dab65c64e66dfd1fbac5be34ba50f7db400e2cea2b"
    sha256 cellar: :any_skip_relocation, ventura:        "28f435dd58671a140bb206c0dc3cde427bf3d65fef0563b59765bec4ce0d9072"
    sha256 cellar: :any_skip_relocation, monterey:       "8fd4c3fc952f40901bfa0be610eef32e6526ff3a1efc737d847ccf127f20be86"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4926d5e0637e8b4179445b8bf8688d7b1a45c25be2ba03c841c0c9f18408822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d36cb6148cee715f3039be3d929547b5438c0dcf8cb78db47c41b5c8f032533e"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid username or password",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
