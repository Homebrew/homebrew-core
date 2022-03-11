require "language/node"

class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-6.1.0.tgz"
  sha256 "c3cbaa3a4d72ccadf1125762895c2714e8474099c9da73c60bd766f17f92fac4"
  license "MIT"
  head "https://github.com/hexojs/hexo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fc97861d0cd43452a8d38ffaa13e452014c4a19c80c609204d0dc7fa267683c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fc97861d0cd43452a8d38ffaa13e452014c4a19c80c609204d0dc7fa267683c"
    sha256 cellar: :any_skip_relocation, monterey:       "a563af9273158a6f25013ac7db09cd19cc43dc37d6b65aa24c019aa4d214338f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a563af9273158a6f25013ac7db09cd19cc43dc37d6b65aa24c019aa4d214338f"
    sha256 cellar: :any_skip_relocation, catalina:       "a563af9273158a6f25013ac7db09cd19cc43dc37d6b65aa24c019aa4d214338f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b69ee97a679ccf8efeebb2a7639fcc5ff0225a39aac32a9fd38ae89ffe6b7ab3"
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
