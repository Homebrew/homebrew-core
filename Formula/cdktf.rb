require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.7.0.tgz"
  sha256 "50d92c7504514dc3a75c6b842e6d83408d5da0fbdec862765ed98b69c08278ea"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d5e67036f10190251af98c5b09d9eb4ed8c4b228e69c79819b56a2de8f8fa75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ad512ddb3d37f0e449631bc2da2a9d3adf73ef909342f1e14e47f6dd244c3ba"
    sha256 cellar: :any_skip_relocation, monterey:       "0fb9080785870bb31d094446f841bc538676546fba27366ffc98e3acfc03ef01"
    sha256 cellar: :any_skip_relocation, big_sur:        "6dd12d395edd05a0fe78fd6b90c017bdf2a7a71b85e8c6cb30af1352f94e0b9d"
    sha256 cellar: :any_skip_relocation, catalina:       "6dd12d395edd05a0fe78fd6b90c017bdf2a7a71b85e8c6cb30af1352f94e0b9d"
    sha256 cellar: :any_skip_relocation, mojave:         "6dd12d395edd05a0fe78fd6b90c017bdf2a7a71b85e8c6cb30af1352f94e0b9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b718800f9a2fc7faebb81dbffe50c2d536e20750d90505aa24092b336cb6bda5"
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
