require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-46.2.0.tgz"
  sha256 "386f40c1726330af86832fc41e776b0f043bf5dfafaa8f9f01038947c124a9eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bbec4224c003c865724b14485bed4ef2c211704b062b4cd74ecf9d4a6dfefe8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bbec4224c003c865724b14485bed4ef2c211704b062b4cd74ecf9d4a6dfefe8"
    sha256 cellar: :any_skip_relocation, monterey:       "017e8d0dad2a96e06fd3d8f488128400008767dd59c93b350a71805cdbcfec12"
    sha256 cellar: :any_skip_relocation, big_sur:        "017e8d0dad2a96e06fd3d8f488128400008767dd59c93b350a71805cdbcfec12"
    sha256 cellar: :any_skip_relocation, catalina:       "017e8d0dad2a96e06fd3d8f488128400008767dd59c93b350a71805cdbcfec12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bbec4224c003c865724b14485bed4ef2c211704b062b4cd74ecf9d4a6dfefe8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
