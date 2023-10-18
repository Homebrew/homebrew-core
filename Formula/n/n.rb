class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v9.2.0.tar.gz"
  sha256 "5ed8a416014abd115e7174aa32ccba29826eebab2188420404f46931f6388eb1"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "436f751158c7c08d9da56191e447faacfb9ac64187ff18a6f58abfa6a1b254eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "436f751158c7c08d9da56191e447faacfb9ac64187ff18a6f58abfa6a1b254eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "436f751158c7c08d9da56191e447faacfb9ac64187ff18a6f58abfa6a1b254eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e523b9ca20514b6769dc985b3ef53a821ec38fef9c4ba43546713654950c9ac"
    sha256 cellar: :any_skip_relocation, ventura:        "5e523b9ca20514b6769dc985b3ef53a821ec38fef9c4ba43546713654950c9ac"
    sha256 cellar: :any_skip_relocation, monterey:       "5e523b9ca20514b6769dc985b3ef53a821ec38fef9c4ba43546713654950c9ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "436f751158c7c08d9da56191e447faacfb9ac64187ff18a6f58abfa6a1b254eb"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
