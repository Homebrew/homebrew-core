class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v3.2.2.tar.gz"
  sha256 "a8eb92bb47f6d00326b710f086aea23ae76ceadd277f79256263f524d3540ed1"
  license "ISC"
  head "https://github.com/isaacs/nave.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e7f74d74b71447c296c6b5873047496a1988e4c7c20fef6af032f7621a15528"
    sha256 cellar: :any_skip_relocation, big_sur:       "6358f668346849c8058739a2bb84757647e2b3612be49446ee849cdd76e102eb"
    sha256 cellar: :any_skip_relocation, catalina:      "6358f668346849c8058739a2bb84757647e2b3612be49446ee849cdd76e102eb"
    sha256 cellar: :any_skip_relocation, mojave:        "6358f668346849c8058739a2bb84757647e2b3612be49446ee849cdd76e102eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7f74d74b71447c296c6b5873047496a1988e4c7c20fef6af032f7621a15528"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
