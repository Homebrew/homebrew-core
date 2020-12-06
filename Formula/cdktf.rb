require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.0.19.tgz"
  sha256 "6464123578fc9bad863eca6152cac4442711d195482907ddfd4f4220d133f94c"
  license "MPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d4cde880cefd8c3daa3a5d2a2d54bc3c547ec5d706c37183c80ee29ba0cdc866" => :big_sur
    sha256 "17cc7f5afc9435c0b77c43661f391a5a7bfcb08d20229db5578c950bb24f41ab" => :catalina
    sha256 "8ad6f2f031ec6a3ba977069f7325e7107fb4016f5d50d18705eb9da2fd1f44b2" => :mojave
    sha256 "d7d23d0f82e6a8721fbab1518ecbdd7428ca8474e38b2bd31505ee8c06590349" => :high_sierra
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
