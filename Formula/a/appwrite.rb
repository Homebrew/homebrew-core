require "language/node"

class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-4.2.2.tgz"
  sha256 "328a2a58166cdd73a2cec41dd9ac88677a58809b37674b5e26270beae8e73f58"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7484d686cf29dffbdd993d4b8fa1a8569fdaf30040fe36d6734d1320a74c4427"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7484d686cf29dffbdd993d4b8fa1a8569fdaf30040fe36d6734d1320a74c4427"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7484d686cf29dffbdd993d4b8fa1a8569fdaf30040fe36d6734d1320a74c4427"
    sha256 cellar: :any_skip_relocation, sonoma:         "000ead456d79e1e6370b4767c36d9752c4a11e473c54681493453f5c9e6c0c19"
    sha256 cellar: :any_skip_relocation, ventura:        "000ead456d79e1e6370b4767c36d9752c4a11e473c54681493453f5c9e6c0c19"
    sha256 cellar: :any_skip_relocation, monterey:       "000ead456d79e1e6370b4767c36d9752c4a11e473c54681493453f5c9e6c0c19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7484d686cf29dffbdd993d4b8fa1a8569fdaf30040fe36d6734d1320a74c4427"
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
