require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.1.tgz"
  sha256 "9cf6e9a0e089e7b39e2d49869f48e168894225dc612039564e6e41df13c63d48"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8729ae0fc296915a0e0e50dc13fb78692751ee18d61f0b782c546018db0774ed" => :catalina
    sha256 "1e27205ad1628968430c9db3a6be3d5319a4858d374a8999eed5e3bb33f9972c" => :mojave
    sha256 "a47fa8f4c0d0d3336b499c9173c4a3bb1145ebd4895647a569d8b0409a43b235" => :high_sierra
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
