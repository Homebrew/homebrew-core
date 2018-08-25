require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-13.0.4.tgz"
  sha256 "52bea96e4ac78e82473a0dd1c5356df22fc8790762e696f5094bf30b43f5039c"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "3d286af287aa77ac157fcc4e976719ed402cfa9244b6ae210ab05ee1db30a74f" => :mojave
    sha256 "1eb42224719407cbf0e1f2f75d13744eb0f2a1fc4c60c4671d4412bf83837048" => :high_sierra
    sha256 "069d3f199917d5c83492728ca8208ab23abcd3871bffb5522d2a4764bf830c2e" => :sierra
    sha256 "8fdc4600be1890b2912fa026e8af8e8ec6b8257832de11740ad01d99ebe8fe25" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~EOS
      { "analytics_reporting": false, "error_reporting": false }
    EOS
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
