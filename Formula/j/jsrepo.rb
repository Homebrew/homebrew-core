class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.4.0.tgz"
  sha256 "55269f9c1bbc5b9f7e85f4c239453d2833d576f52242a680aadfe14498e45686"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6984d2882ee8ab8e19c494255c4e242c934de0a99fed5f102f873214618a38c8"
    sha256 cellar: :any,                 arm64_sequoia: "8746fccb6f2a9b9bc32461db8108c86be0b80910445611e1b5ccc495adecfe44"
    sha256 cellar: :any,                 arm64_sonoma:  "8746fccb6f2a9b9bc32461db8108c86be0b80910445611e1b5ccc495adecfe44"
    sha256 cellar: :any,                 sonoma:        "54c2ec2cb6d8c8125f87bf2f629e74a95589ceff666058e1bc4ee25600aaca42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8663bd22504ed8fe68e7f83568076218a5bc6096bea73a784b329e11a2ba08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67de74eefd00c7352e6133a05ac249551a7658557f21cee1132bea22ff8cf269"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end
