require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/ios-control/ios-sim"
  url "https://github.com/ios-control/ios-sim/archive/9.0.0.tar.gz"
  sha256 "8c72c8c5f9b0682c218678549c08ca01b3ac2685417fc2ab5b4b803d65a21958"
  license "Apache-2.0"
  head "https://github.com/ios-control/ios-sim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "36da0b5e859153bd745a49214df77b469c2b5211e2c11a2dd7d711ff1cfdf914" => :big_sur
    sha256 "54028aa5938c6a5f7e4f2106b31e47a18778961bdb8c3ae73f8935a569c91764" => :arm64_big_sur
    sha256 "8c48bcbabb9ddb5b3781c16a2af67518881ff23bd5d7f0723436cb438ef7088e" => :catalina
    sha256 "87ddbe7f7341fa207ac5d4a1212e81a3fe838c474bdbcbc2c7239ac2bf8ccc7e" => :mojave
    sha256 "ddbe9d541710ab4dd219db3f766e878ff8698dcd88c25a247e5c44e165ea2773" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ios-sim", "--help"
  end
end
