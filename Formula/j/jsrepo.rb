class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-1.38.0.tgz"
  sha256 "63f54881cb415254b7194ee12c8503da4ae7d8c72ce0d4da3a54960bb6689b6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0696c30e6adb61c1211decd613cded096207d6c54967c0d00d8042e13c6a8e6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0696c30e6adb61c1211decd613cded096207d6c54967c0d00d8042e13c6a8e6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0696c30e6adb61c1211decd613cded096207d6c54967c0d00d8042e13c6a8e6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "73f4e978edff8159e9762734472fb74efe1998db8aea43e3c13d7bfdca9c68e8"
    sha256 cellar: :any_skip_relocation, ventura:       "73f4e978edff8159e9762734472fb74efe1998db8aea43e3c13d7bfdca9c68e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0696c30e6adb61c1211decd613cded096207d6c54967c0d00d8042e13c6a8e6d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/jsrepo"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end
