require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/ios-control/ios-sim"
  url "https://github.com/ios-control/ios-sim/archive/9.0.0.tar.gz"
  sha256 "8c72c8c5f9b0682c218678549c08ca01b3ac2685417fc2ab5b4b803d65a21958"
  license "Apache-2.0"
  head "https://github.com/ios-control/ios-sim.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1a5c50ae49619b4df9dee4cfd1f010de791d35d939cf4a635e68dd1ba6a8fd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54028aa5938c6a5f7e4f2106b31e47a18778961bdb8c3ae73f8935a569c91764"
    sha256 cellar: :any_skip_relocation, monterey:       "e741d066f12c6325452d5b65ea9894ade7878a6c85304c4b75f56f1c21563a33"
    sha256 cellar: :any_skip_relocation, big_sur:        "36da0b5e859153bd745a49214df77b469c2b5211e2c11a2dd7d711ff1cfdf914"
    sha256 cellar: :any_skip_relocation, catalina:       "8c48bcbabb9ddb5b3781c16a2af67518881ff23bd5d7f0723436cb438ef7088e"
    sha256 cellar: :any_skip_relocation, mojave:         "87ddbe7f7341fa207ac5d4a1212e81a3fe838c474bdbcbc2c7239ac2bf8ccc7e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ddbe9d541710ab4dd219db3f766e878ff8698dcd88c25a247e5c44e165ea2773"
  end

  depends_on :macos
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ios-sim", "--help"
  end
end
