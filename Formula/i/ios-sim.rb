class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/ios-control/ios-sim"
  url "https://github.com/ios-control/ios-sim/archive/refs/tags/9.0.0.tar.gz"
  sha256 "8c72c8c5f9b0682c218678549c08ca01b3ac2685417fc2ab5b4b803d65a21958"
  license "Apache-2.0"
  head "https://github.com/ios-control/ios-sim.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bd92e6e258c08fa9311aa30268b4ca011cdc433deaba18f2f61056c36e09431a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e73a7f221630697eab12ddbd235c47bc13274d1901ae108bd38f4cba5d5b6a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e73a7f221630697eab12ddbd235c47bc13274d1901ae108bd38f4cba5d5b6a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e73a7f221630697eab12ddbd235c47bc13274d1901ae108bd38f4cba5d5b6a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa7b613231b370eb5cf3577fe6cfade02cb01fbbf71925a1e2b8915c93216e4a"
    sha256 cellar: :any_skip_relocation, ventura:        "fa7b613231b370eb5cf3577fe6cfade02cb01fbbf71925a1e2b8915c93216e4a"
    sha256 cellar: :any_skip_relocation, monterey:       "fa7b613231b370eb5cf3577fe6cfade02cb01fbbf71925a1e2b8915c93216e4a"
  end

  depends_on :macos
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ios-sim", "--help"
  end
end
