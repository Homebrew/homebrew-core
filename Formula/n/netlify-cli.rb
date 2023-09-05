require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-16.2.0.tgz"
  sha256 "f04e8c1efc097087f7444de7eae272561b8f35689aa87ce578d0aa8d5af2e1e9"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "5edb9060eaac28cf3bfbef65033e87858a60bdab5f19c68f4160eaa569328871"
    sha256                               arm64_monterey: "656e84ba5842f9ff8a65abeb6aef48d400e73c0b91f8539d7e2f27d55b7b67be"
    sha256                               arm64_big_sur:  "68e2cd3e0e63bc4f27b1e6e1b9687057bbc6013c36b52e1e08ab9a3bb67ca4c3"
    sha256                               ventura:        "41d0662e2bcae311ae315637819c35d92f422040ae266726b92e4bdbd1e4e20e"
    sha256                               monterey:       "a0036b7bbc20ac39ca4491c71b6ad7a5fa40aa23ed14a32659141d3486023aeb"
    sha256                               big_sur:        "9d8c252633c565e7c071e77df709254b172ff6ffc46d4cbb3f289e73208a7ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d48ead86dd794c67de8e1856a74c95c87c4c1b23845119e93d79bb62da7c1ca9"
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
