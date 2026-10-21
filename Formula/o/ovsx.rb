class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-1.3.0.tgz"
  sha256 "bbdd792bc80942daceb8b79d8c1b35fb392e82aa3a8c7450e46aeafb86c9f45d"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fecdce141c37ee386b14c6d8a94842ee0eebec1bcd041e5601f11239d7acacab"
    sha256 cellar: :any, arm64_tahoe:       "fecdce141c37ee386b14c6d8a94842ee0eebec1bcd041e5601f11239d7acacab"
    sha256 cellar: :any, arm64_sequoia:     "fecdce141c37ee386b14c6d8a94842ee0eebec1bcd041e5601f11239d7acacab"
    sha256 cellar: :any, arm64_linux:       "b96cd66ca60bb0e3b800d6224fd9314d0220f11e5f132b9e431229df4ea1a025"
    sha256 cellar: :any, x86_64_linux:      "18047ac9c1b3d69ac9102016be57528917f6f802a763a3e6d2f24c6e227ef68b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/ovsx verify-pat 2>&1", 1)
    assert_match "Unable to read the namespace's name", error
  end
end
