class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.4.0.tgz"
  sha256 "23b1dc5d22f8e72010883c961cf2b8491aa2ea6ff9f4dc2d3f87b6e2069755dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce68402017d66b4db9e396bba2bbbbc73b4c8a770afddec992dd6df6c1c10230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce68402017d66b4db9e396bba2bbbbc73b4c8a770afddec992dd6df6c1c10230"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce68402017d66b4db9e396bba2bbbbc73b4c8a770afddec992dd6df6c1c10230"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b1446c3bf162cbca8d3a98508cb42704c019ddaeb076adb839be14b5c382e50"
    sha256 cellar: :any_skip_relocation, ventura:       "0b1446c3bf162cbca8d3a98508cb42704c019ddaeb076adb839be14b5c382e50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce68402017d66b4db9e396bba2bbbbc73b4c8a770afddec992dd6df6c1c10230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce68402017d66b4db9e396bba2bbbbc73b4c8a770afddec992dd6df6c1c10230"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https://github.com/usebruno/bruno/issues/2229
    (bin/"bru").write_env_script libexec/"bin/bru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bru --version")
    assert_match "You can run only at the root of a collection", shell_output("#{bin}/bru run 2>&1", 4)
  end
end
