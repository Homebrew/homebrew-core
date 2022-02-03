class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v3.2.3.tar.gz"
  sha256 "cd7c1f6f87b1dd83cbed52b5f101bb4fce8448030be85f5de034599179d84b78"
  license "ISC"
  head "https://github.com/isaacs/nave.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3713cbd8e1945c7af7a5582c0e85ad1f4ca03dc4820d48472921c20f03ee16b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3713cbd8e1945c7af7a5582c0e85ad1f4ca03dc4820d48472921c20f03ee16b7"
    sha256 cellar: :any_skip_relocation, monterey:       "617b3d4825d3fa11020eb73f5bdcd4ee5b2844b5bab084ef7ed821c588a32fac"
    sha256 cellar: :any_skip_relocation, big_sur:        "617b3d4825d3fa11020eb73f5bdcd4ee5b2844b5bab084ef7ed821c588a32fac"
    sha256 cellar: :any_skip_relocation, catalina:       "617b3d4825d3fa11020eb73f5bdcd4ee5b2844b5bab084ef7ed821c588a32fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3713cbd8e1945c7af7a5582c0e85ad1f4ca03dc4820d48472921c20f03ee16b7"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
