require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.16.4.tgz"
  sha256 "dcaee23bbed63e3c278a934394a2cbef3ff896d12cc10ffae67f38960ce7d979"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad4d3587344dadc5a41894350cd78ef87e32b6eeaf15e19fa259230acdb48029" => :mojave
    sha256 "ebebca0bb59b1f6fb0c051cb900ed84490fd382f1ebe83fabc11164084959298" => :high_sierra
    sha256 "e5fb1d244c72686e2b4744723f4b955def887ca069449a71935d0ebbbfbe4256" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
