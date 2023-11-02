require "language/node"

class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-7.0.0.tgz"
  sha256 "240fee6cb09e4f57a7d28acfb43e4b4daae078d6402c7f9538bc2daeb6c4e539"
  license "MIT"
  head "https://github.com/hexojs/hexo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3632ba768033d12bb7b368335872e39bed5e640f6857b0d992bdcb2597316d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3632ba768033d12bb7b368335872e39bed5e640f6857b0d992bdcb2597316d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3632ba768033d12bb7b368335872e39bed5e640f6857b0d992bdcb2597316d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "78d7610fd35dc53ff1bfe7aaf14a6ebe7b013b6974a5c2d0774f8b8d15bfb5de"
    sha256 cellar: :any_skip_relocation, ventura:        "78d7610fd35dc53ff1bfe7aaf14a6ebe7b013b6974a5c2d0774f8b8d15bfb5de"
    sha256 cellar: :any_skip_relocation, monterey:       "78d7610fd35dc53ff1bfe7aaf14a6ebe7b013b6974a5c2d0774f8b8d15bfb5de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5672c9ea5b39b77a6830c741f791983eab68b74b797958d5cc977b0b2977b72a"
  end

  depends_on "node"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/hexo --help")
    assert_match "Usage: hexo <command>", output.strip

    output = shell_output("#{bin}/hexo init blog --no-install")
    assert_match "Cloning hexo-starter", output.strip
    assert_predicate testpath/"blog/_config.yml", :exist?
  end
end
