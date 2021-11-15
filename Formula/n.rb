class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v8.0.0.tar.gz"
  sha256 "9e8879dc4f1c4c0fe4e08a108ed6c23046419b6865fe922ca5176ff7998ae6ff"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fa15a18556ed914c2a8ff7505ea084e4685e8da5d166c96a98e3297ddefc000"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fa15a18556ed914c2a8ff7505ea084e4685e8da5d166c96a98e3297ddefc000"
    sha256 cellar: :any_skip_relocation, monterey:       "43dbc0e42d23a9c30454f177dbe2ee6b65db1d967b7b0a8c15552087bf2f8dd3"
    sha256 cellar: :any_skip_relocation, big_sur:        "43dbc0e42d23a9c30454f177dbe2ee6b65db1d967b7b0a8c15552087bf2f8dd3"
    sha256 cellar: :any_skip_relocation, catalina:       "43dbc0e42d23a9c30454f177dbe2ee6b65db1d967b7b0a8c15552087bf2f8dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fa15a18556ed914c2a8ff7505ea084e4685e8da5d166c96a98e3297ddefc000"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
