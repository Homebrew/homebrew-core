class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://www.contentful.com/developers/docs/tutorials/cli/"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.13.tgz"
  sha256 "afc3ebcc51e3074112b2e68c867655474e7d5c6e4728fb96e4841cc96b415b32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "451358c5ca5841eb5dcff4a3db8078f2560c08cf8c36bb089ba111ee187bc685"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "451358c5ca5841eb5dcff4a3db8078f2560c08cf8c36bb089ba111ee187bc685"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ec75d26ae9339f60648c31a30dfc420890871c664a13fa06d5f9fd06ab56a0c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ed2146d7b88ea5091f50ff3a34e9bdab2d1255cf339b04b48fc96886b8022104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9b8725d20aaf1165ab66c1a4f7ba9d2253deb68eed8ccf7475207a4789bc8ae0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
