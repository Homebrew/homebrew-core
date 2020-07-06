class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.21.3.tar.gz"
  sha256 "012651a79e47150de4a386d1c3c81a017d5ceac14f5a0c24b0596a2215cde8be"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d27ce73fbfdf133817b8e25f217d935be47a2467aa2f008d8ae2ef0ffaeccf4" => :catalina
    sha256 "1b16dd8e83fd2463744faad358496812599d8844eb773c62947652958d20662d" => :mojave
    sha256 "4b5a41fc1184ff2362f9558b9e822821b350aae36a98ec81bb2c70c9f1bc9bed" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
