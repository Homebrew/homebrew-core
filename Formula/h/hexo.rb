class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-7.3.0.tgz"
  sha256 "807b356fef2aa9623788b0e2b997fc6955c4c0a2a70fc1a8776c281194e4277e"
  license "MIT"
  head "https://github.com/hexojs/hexo.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8a1d3ba84fcc6755801b4e0d7838adb598b651c8ac4648b33bcbdff5797a5a20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "209a443cc5a02dd08fad22385e10e453b903b22ab90d0c19a825da1bcba3d6be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "209a443cc5a02dd08fad22385e10e453b903b22ab90d0c19a825da1bcba3d6be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "209a443cc5a02dd08fad22385e10e453b903b22ab90d0c19a825da1bcba3d6be"
    sha256 cellar: :any_skip_relocation, sonoma:         "e44df1e02afe2df6e9957c624aa306392d7ef6e9273a65bad30cce1826644443"
    sha256 cellar: :any_skip_relocation, ventura:        "e44df1e02afe2df6e9957c624aa306392d7ef6e9273a65bad30cce1826644443"
    sha256 cellar: :any_skip_relocation, monterey:       "e44df1e02afe2df6e9957c624aa306392d7ef6e9273a65bad30cce1826644443"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0492ce8c52b9c4040646909acf29b5d237855026d982304e137f497a2bf4455e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "803c580e42eadd1f4dd66bcb435bbc117df28b3a1e6a9c0c85551940d9d3c79a"
  end

  depends_on "node"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/hexo --help")
    assert_match "Usage: hexo <command>", output.strip

    output = shell_output("#{bin}/hexo init blog --no-install")
    assert_match "Cloning hexo-starter", output.strip
    assert_path_exists testpath/"blog/_config.yml"
  end
end
