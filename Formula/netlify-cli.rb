require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.0.2.tgz"
  sha256 "24a89d948897ccbbffbac68238e4754a62a947e3972afe8368c5c095be0c265a"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "9a2cbbda0a5f49a748f1b0644c3cc04d8520577db3d180bb077b6b67a90c3fe5"
    sha256                               arm64_monterey: "2797629bf84de39894130c91651bd33caf096a7d0e0de4a36474b016fef56d07"
    sha256                               arm64_big_sur:  "d9016aae0fd9924e032bc3f54003aa308abc27f90024458e195d2615d1dce2c3"
    sha256                               ventura:        "528398ade43eeff8130b530997331f6c9950b9bf230b5573a0b12398101dc102"
    sha256                               monterey:       "58c7cbfbb640f14fad583556c7081ac2d375ba3501d246dccebeea202121d7a7"
    sha256                               big_sur:        "5fd5bd1563477daedc36f37d7dd8fd0f54ee65c7ed9dae4bd11d023977d53d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0885d36b39ff76f8885e1d6905913df039ed4f440638b55cbac16582cde81b0"
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
