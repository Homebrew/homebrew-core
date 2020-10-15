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
    sha256 "dffd4f49151ea3126d9b50bba08a684b1395fb2303b2c5ccab4fbf37babd8bf7" => :catalina
    sha256 "b5d0dc978f57ad3fa38a4035c552b36d24bef8931b0e5519d2278b9a32afcf6f" => :mojave
    sha256 "04e3e8904788a18d27e39d23c8cd4d478e1c3f25f81be3105e43b67894f4c1b8" => :high_sierra
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
