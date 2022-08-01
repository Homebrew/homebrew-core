require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.13.0.tgz"
  sha256 "7d8b5293767cc28e17d2e63456005e1dab654b6a3ab2a538d72747faa5a3c722"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3719df5ff383da51eea5a2cf244ac08f596c26b3ec96af9ce5cdbdb5678675d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3719df5ff383da51eea5a2cf244ac08f596c26b3ec96af9ce5cdbdb5678675d7"
    sha256 cellar: :any_skip_relocation, monterey:       "c7aa8ea285efbda5358d9c1558ffad086a39f88eab831bb5b7e296a676ab58c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7aa8ea285efbda5358d9c1558ffad086a39f88eab831bb5b7e296a676ab58c6"
    sha256 cellar: :any_skip_relocation, catalina:       "c7aa8ea285efbda5358d9c1558ffad086a39f88eab831bb5b7e296a676ab58c6"
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
