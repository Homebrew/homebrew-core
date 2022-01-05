class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.30.3.tar.gz"
  sha256 "7fb5431b98d57fb8c70218b4a0fab4b08f102790e7a92486f588bf3d5751ac3b"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c006b9c0537cf53d441f1ae9536f9cc01de17f87aa943051901b580900ba370d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2eb33e0de4a967a814e2f4dd36f856e8777fb4e2f430f127ede51bd196efd45"
    sha256 cellar: :any_skip_relocation, monterey:       "1c6c61408ec9b3eee8b53ff72558ac69c80e28a72a9d4e808c7b5248471fdabf"
    sha256 cellar: :any_skip_relocation, big_sur:        "004aee20ae5bf4f8481439ef010425c32ca059af9102e380b67e6dc163250408"
    sha256 cellar: :any_skip_relocation, catalina:       "02ecc1d121ca367ba5a7fb83eb5cd7768eceffb52c52e0334943794bd5462ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dca3295589a8566d5250265b3a4ec2c3ef8eb73eac6777d8a193969ddf6c9220"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
