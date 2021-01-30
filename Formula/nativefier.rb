require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-42.2.1.tgz"
  sha256 "97011d32878e7a6a69e827846f023e7aa2975976c5fc984d250f9dcd0d8f1f0c"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c06dbbba78ffa01f9fd378a8ad57279df0e8ae888031600672f9eb6bf24bdb2d" => :big_sur
    sha256 "c8594f45fe1dfa480dfa57cda859d2e473229a94a05a7c39157ce1d804daf6d9" => :arm64_big_sur
    sha256 "25f5d5cd9320e000ff0511d5d1d657e48336bd3c43a86418f5f87bc0fd67fcbd" => :catalina
    sha256 "2d9c67186099f3782fe0223427de7fa540b8c470435df7aaede594851400e152" => :mojave
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
