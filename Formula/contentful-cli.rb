require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.13.tgz"
  sha256 "bd294f335ea1c6014ec37ce2e147563cd108f7adc49e2ebbc498e9a6b8cdf003"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a67d5d44605abe85c755a7e3b7cea1be3997f77feaafdf486c709ba71d9ccf62" => :catalina
    sha256 "102d7bb318832c3e71864db5bf07fb35725aef22dd9420ce7b83674a4dab780b" => :mojave
    sha256 "56f742d78ce5602e2cec91fcde71ddaf002a99ec72dd7cea80ba885394ed8c9b" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
