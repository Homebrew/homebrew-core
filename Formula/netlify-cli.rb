require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.0.10.tgz"
  sha256 "8450b270adf0e102d53f14570bfcc17ca431319cb07322c18f62625ca66faab8"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fefd1700a3dfea53223f303e49d6d0bf7457d5bfb5cd00df7a87544d931d0bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fefd1700a3dfea53223f303e49d6d0bf7457d5bfb5cd00df7a87544d931d0bd"
    sha256 cellar: :any_skip_relocation, monterey:       "71b63e2215aec6b6796dd1f28db8998f14bdaff7262c5dd1ed29c1101bc1bd1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "71b63e2215aec6b6796dd1f28db8998f14bdaff7262c5dd1ed29c1101bc1bd1c"
    sha256 cellar: :any_skip_relocation, catalina:       "71b63e2215aec6b6796dd1f28db8998f14bdaff7262c5dd1ed29c1101bc1bd1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "824ea6566f8b016a06601926069d37bea47f4fa734c25758b51e41683e1eeea7"
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
