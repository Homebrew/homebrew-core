require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.5.1.tgz"
  sha256 "0c749651e367370d8acee446c36424e155b6afc74936d7e4f3ef727807a5f313"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_sonoma:   "86dcf03e2ddfe1ca291331e12457f60b0c934434349ef58a2525998c88d74eed"
    sha256                               arm64_ventura:  "812e8badbea2f7bb88fb9b35f90352ada3089f15477e0274f15bd2b6ff865b1e"
    sha256                               arm64_monterey: "6d9725041aa3ac52e6bbd66c0824943250b5ec99b277df084f76809a8b25236b"
    sha256                               sonoma:         "8fbda890cdda71fd9531e3b913fe8f5c3884eb5489805a4b532ddd1c7f46e322"
    sha256                               ventura:        "d2860a95614e299fc0a3748db319b709f11dc7c9d83e4ca174c9993b4c8ffa19"
    sha256                               monterey:       "faebe5fab07a4cfd3bc40524b72b5d902f444f4cdb9f2a26bcdcf48e35fb4db0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0893fa32c4766dd883888265412bec3a0b888746410b96c3e9dc294ccfb4ecfa"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
