require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.7.2.tgz"
  sha256 "98ef0d7a81886afd08ec91a46fa98f4ddbe7ca676a2319d983b8eedc2d895984"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90c63060525c35d0535bcad38f4486dda9d51428d31ab909f9739b210a728db4" => :catalina
    sha256 "1440522afb1b3ee98db0d8c91d99e69052dae928298c063ff4e27103dbdba8e1" => :mojave
    sha256 "a960d063839b4d00c925fde6c14cde22057b273f91c94b4df96eb158a59f8027" => :high_sierra
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
