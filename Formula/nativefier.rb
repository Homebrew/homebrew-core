require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-42.2.0.tgz"
  sha256 "64f28633b83d5e82e3aedbdf874b687f81e48ec2e0c4593ff7c24545738fa79b"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "84f6c924bf750f8636abaf5f996d64328c9f26f228115d9749f56d64ae6c2f55" => :big_sur
    sha256 "373bd45630fe672e9511892e515db341abdc36def22a4b91bdd55cc385779366" => :arm64_big_sur
    sha256 "59d17a28db9fd8f7236f7af5214708fe103beb6fa6250bca9003ead60700fa86" => :catalina
    sha256 "500121f8263dcb70123f11c864e7de59a52753caaf1a03d6fbfd52e571a0ce6c" => :mojave
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
