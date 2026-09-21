class Inshellisense < Formula
  desc "IDE style command-line auto complete"
  homepage "https://github.com/microsoft/inshellisense"
  url "https://registry.npmjs.org/@microsoft/inshellisense/-/inshellisense-0.0.4.tgz"
  sha256 "413c9a1657bb5b31353dbb372e25934a712c57857bd09199889f6cb64c441fb7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1585e5f227d1cf95c81b37329a7f36b7167dd056bfa455c3d034f88c6499f88"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d1585e5f227d1cf95c81b37329a7f36b7167dd056bfa455c3d034f88c6499f88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1585e5f227d1cf95c81b37329a7f36b7167dd056bfa455c3d034f88c6499f88"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c1b13788021aa1ce15389fdf8fa81348041059eff0ac3fee7f5e4debfd5d4fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fd80c8ced83382e565265d99f655e7f1ceff58851fbe2cd48d2f72c19802e197"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "inshellisense session", shell_output("#{bin}/is --check")
  end
end
