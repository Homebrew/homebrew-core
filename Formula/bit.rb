require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-13.0.1.tgz"
  sha256 "4b4fdccb1a0894f91eb1b96ad3455dcb8df861820cab34635c88536c86752773"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "f5efca4a739f502afa2519a3680ef170998378c4078072033dfe4e4469f6b0ff" => :high_sierra
    sha256 "076ba75aa317573ab45d708c40f7f5646ddd7ac8234d5f750feb6c7f9ade4574" => :sierra
    sha256 "218c930153ec0c2b23cb3f32c42556cc548f93d5b314356d98a3db2e0bd6b199" => :el_capitan
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
