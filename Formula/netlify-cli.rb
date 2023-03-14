require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  # netlify-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-13.1.5.tgz"
  sha256 "04f4dc7685e7201b461a4480722fd3f6c0d44e91a78428117737af9616d8d278"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "59eb1eae0b00295146125a5081b2193d413258efcbc6fe24d6a94baefe52c10c"
    sha256                               arm64_monterey: "8cfcd119276295044702f81153b6ff3d2b8bba0a9bf2cbfb7eb48978089aeb53"
    sha256                               arm64_big_sur:  "a42fd619495d2809353ef6284198ade374cf6afc0671e81e4a765ae0c825bd10"
    sha256                               ventura:        "0f785a026d5bc92671921d13dea36090379294aeb28605c24ca8ba568e0822ad"
    sha256                               monterey:       "426a25f23219df31685965abb80fe4f42fed1f31e6602bec60c70e8f71e1944e"
    sha256                               big_sur:        "b8e89ac69d3a1614b91679ad92150456c94cdcb5197e43ad191706ca5b4b6bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eba4153e54691888bd48225ca1f4c6f9c6ec35e037e6b9af5b696087b8d8120"
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
