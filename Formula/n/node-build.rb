class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "c6c48f332e5ce94a36aff5292abbd9ebd0bfe6014383a4afde969df8a1164a66"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7a64169a0ba12206bb6bde868645b16909916426ae9ac15ddcad11b51524d07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7f5b9aee5c74c5e708794926303fc07235acdbf26f4c4011c80b550da83375a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "708b9b85e8ad09870b1b7c5cb4315aadf35dfcd26141745fc9ca7d23ffa5d7b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e19b2eed160f968138695f6ebbc2aad2119d8040a94eb2a4dff2031d9b2eb29"
    sha256 cellar: :any_skip_relocation, ventura:        "ef75d82f7857c4b1f6c55a0132215ff6129f1509f512c21864a502fd83f836a4"
    sha256 cellar: :any_skip_relocation, monterey:       "8c347c126604d456f67de80b5a6266e9bdb875ebd9ede27072d72b77a3a801f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b16dfb273e68314f5d4754cce726e4b3ba0a78caae4399ba4f0550462ae1da1c"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
