require "language/node"

class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-5.0.1.tgz"
  sha256 "7ea4c4dbdc6ae6a9700a3b403a050f3d125e78eb479bd5b7db1bb32f61159944"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cd4cb392a057b5cd82992b48c25e6eb17efc9d57963212c8a23eca13132bb99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cd4cb392a057b5cd82992b48c25e6eb17efc9d57963212c8a23eca13132bb99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cd4cb392a057b5cd82992b48c25e6eb17efc9d57963212c8a23eca13132bb99"
    sha256 cellar: :any_skip_relocation, sonoma:         "da1c296c4e8ea3d1e4e781272e4356ccf04d1b99147809b1a8d3864426197251"
    sha256 cellar: :any_skip_relocation, ventura:        "da1c296c4e8ea3d1e4e781272e4356ccf04d1b99147809b1a8d3864426197251"
    sha256 cellar: :any_skip_relocation, monterey:       "da1c296c4e8ea3d1e4e781272e4356ccf04d1b99147809b1a8d3864426197251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cd4cb392a057b5cd82992b48c25e6eb17efc9d57963212c8a23eca13132bb99"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
