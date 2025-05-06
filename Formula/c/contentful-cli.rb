class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.8.8.tgz"
  sha256 "de28b9aaaea30c79543d867ac1f55f3638ecdf51ecef6a79d9c7ba3ed1cf6fdc"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "545f40ea5afd8b629a75d67e809e0db92c0e70daa6e1e8a7b4427839dad47597"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "545f40ea5afd8b629a75d67e809e0db92c0e70daa6e1e8a7b4427839dad47597"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "545f40ea5afd8b629a75d67e809e0db92c0e70daa6e1e8a7b4427839dad47597"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6db3ae109bb33abc92d9d31368cc66a3d826dc19713487d0313fff004d28048"
    sha256 cellar: :any_skip_relocation, ventura:       "e6db3ae109bb33abc92d9d31368cc66a3d826dc19713487d0313fff004d28048"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "545f40ea5afd8b629a75d67e809e0db92c0e70daa6e1e8a7b4427839dad47597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82fd349f267efa4366b2780156a3d72da004297e13b0f3b65d284134515cfd6c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
