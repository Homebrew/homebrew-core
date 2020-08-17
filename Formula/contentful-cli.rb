require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.23.tgz"
  sha256 "561b37762610ac4c19eea6a366ed9fa2f23a0d1136e57a8fce14cc1df3836f65"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcb81cb6ba754f7b6b81986dc8fe8296db17d58ba15a7db90b8694fa00f89a8b" => :catalina
    sha256 "461150a3914c2af68534fea30cd87b80d5b288a4d450877ecf8b248948c077a5" => :mojave
    sha256 "cf20029c144ad258639d9ec00890af6df220b882bca086ac4fbd780d67577578" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
