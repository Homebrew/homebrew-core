class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v3.5.0.tar.gz"
  sha256 "009c96bdbbef66180796feb94b75e13a394934bc7093621851a19a1ab7d2916d"
  license "ISC"
  head "https://github.com/isaacs/nave.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aac5527ec1b90826ec308809a6cd8001ad3ba56f1380d0b56b55ab448926c6e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aac5527ec1b90826ec308809a6cd8001ad3ba56f1380d0b56b55ab448926c6e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aac5527ec1b90826ec308809a6cd8001ad3ba56f1380d0b56b55ab448926c6e1"
    sha256 cellar: :any_skip_relocation, ventura:        "f33d1100b6c3beb7dd5ca9ec72b2cfbe81515a3f8002a21c276a208f41236198"
    sha256 cellar: :any_skip_relocation, monterey:       "f33d1100b6c3beb7dd5ca9ec72b2cfbe81515a3f8002a21c276a208f41236198"
    sha256 cellar: :any_skip_relocation, big_sur:        "f33d1100b6c3beb7dd5ca9ec72b2cfbe81515a3f8002a21c276a208f41236198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aac5527ec1b90826ec308809a6cd8001ad3ba56f1380d0b56b55ab448926c6e1"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
