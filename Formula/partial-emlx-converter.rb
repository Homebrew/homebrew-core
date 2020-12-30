require "language/node"

class PartialEmlxConverter < Formula
  desc "Convert .emlx and .partial.emlx files created by Apple’s Mail.app to .eml"
  homepage "https://github.com/qqilihq/partial-emlx-converter#readme"
  url "https://registry.npmjs.org/partial-emlx-converter/-/partial-emlx-converter-3.0.2.tgz"
  sha256 "1901218bbb96b42e710c31e8524ca746354cd0c940639d18bc1aeab3beff0c0f"
  license "MIT"

  livecheck do
    url :stable
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # expect exit code 1
    output = shell_output("#{bin}/partial-emlx-converter", 1).strip
    expected = "partial-emlx-converter input_directory output_directory [--ignoreErrors]"
    assert_equal expected, output
  end
end
