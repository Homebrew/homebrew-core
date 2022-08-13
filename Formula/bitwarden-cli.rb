require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2022.8.0.tgz"
  sha256 "6a9f6f2be0c8ed08ee7a35aefb15b31889a4dac83bf49ba95e67542ba682e153"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e7ed331859a3097e3d1e991c3f41089c8426f3469e6c317b3f4feed69036186"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e7ed331859a3097e3d1e991c3f41089c8426f3469e6c317b3f4feed69036186"
    sha256 cellar: :any_skip_relocation, monterey:       "4f608066b25d6f473c9feb584d5fead9934a3bda79210afaf94e22729893d093"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f608066b25d6f473c9feb584d5fead9934a3bda79210afaf94e22729893d093"
    sha256 cellar: :any_skip_relocation, catalina:       "4f608066b25d6f473c9feb584d5fead9934a3bda79210afaf94e22729893d093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e7ed331859a3097e3d1e991c3f41089c8426f3469e6c317b3f4feed69036186"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end
