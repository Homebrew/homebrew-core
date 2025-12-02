class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-0.10.7.tgz"
  sha256 "74f82371e0d0ba3ce7ceb3a49e6e06dc8323d8ebc05a6764cd1fffbbcf09ccb8"
  license "EPL-2.0"

  bottle do
    sha256                               arm64_tahoe:   "e427e4992a6dbf269c4eaf1de8a95ab3c3fc9ad39fee183a116fd0a59e80be7b"
    sha256                               arm64_sequoia: "8617f49925a1b7aff82ad37897e4e63760fd9e2b91657d323c466ce875d94a11"
    sha256                               arm64_sonoma:  "5fac4075d52c22062da7978fdcf25153f95795cd49f062f1e34d75a260a392fc"
    sha256                               sonoma:        "c33eafc72cfcb5b0b3c89e6e4e8e911fe48feff5122fd8c87e6fa0052a14283c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21650d33785b07df120de9841f42af6104c6d606b0e3c407a5871ac83d4d4324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e025efef6eb7b2f51f9d01695b00cea6bbbf1c1d3643ac71f072def4330c856"
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
