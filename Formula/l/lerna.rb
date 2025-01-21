class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.1.9.tgz"
  sha256 "46ceaeb4be5db0bda1faba4ec236edc04c94e6945d6805877b17ce9b5f28e810"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5fa117222b25d1345ff99518fdfb31f7c9b650ebdc57597aa08d6a744cf4a617"
    sha256 cellar: :any,                 arm64_sonoma:  "5fa117222b25d1345ff99518fdfb31f7c9b650ebdc57597aa08d6a744cf4a617"
    sha256 cellar: :any,                 arm64_ventura: "5fa117222b25d1345ff99518fdfb31f7c9b650ebdc57597aa08d6a744cf4a617"
    sha256 cellar: :any,                 sonoma:        "ae501da933f2f810b7556cf98fafc2bfb2207c19da116b07c29e978adb1f83d6"
    sha256 cellar: :any,                 ventura:       "ae501da933f2f810b7556cf98fafc2bfb2207c19da116b07c29e978adb1f83d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce88ab2b08db367035ef6575dfc5a6e6a37f3423d6c79fe87fd755ed59b65bd2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
