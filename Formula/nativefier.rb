require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-10.1.0.tgz"
  sha256 "8a0984dc0c85eb87bfdb6e921c0dd53f722736907c2ccbb1dd78fd47c655f8ab"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9af138aa796efacc377de35b1020091e48a7c3c1ffca3ca32b7ed603dba00a93" => :catalina
    sha256 "95e4333fe5aa40f5fa0bfc004b902454547e4ddadceb16903fb310fbba28e537" => :mojave
    sha256 "3de61007eb5af8c64c52362fa540d098c169c8433fc689edfa0a7075e5b03756" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"nativefier", "--version"
  end
end
