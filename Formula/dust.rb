class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.7.5.tar.gz"
  sha256 "f892aaf7a0a7852e12d01b2ced6c2484fb6dc5fe7562abdf0c44a2d08aa52618"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6edca1e8a6965f9a88bce456deb43d05270c732b5486666754595de01693026"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96f49e81189c0120c16bb3da858f7a9c6daad1fba6efaeccf6a3d0d34ce1253b"
    sha256 cellar: :any_skip_relocation, monterey:       "e32c73ed14a8ef6e0f17ab6346b4bb497acdb243da0edeebc35acdfd4be6c191"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e21970d1f6b01d5c472c9a56f4d2415f721d3534fb600cf3dd22782c7b10294"
    sha256 cellar: :any_skip_relocation, catalina:       "1c9527d0399c8b1235c9291b448bfb30c0a4590fd4e9129d17b4bbbbe6ace74a"
    sha256 cellar: :any_skip_relocation, mojave:         "b044d0c3122ea62432349dd64374ca257d5e9265f158973a2e11ceaf8955cb1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ea0ed558b2941ac32109b8b8a83bf4f55c3177b26a7b1436e98c71616cf822c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
