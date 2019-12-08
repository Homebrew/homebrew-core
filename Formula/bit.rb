require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.7.0.tgz"
  sha256 "dc837b00c13f7f428e53b1e087571d3ca9c852e09ca7a2ed094adfc0e685c770"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef01da2fb0caabd52ed3bc8771b6cb7078d6457ca971d1325e7fc4f0b06fa1da" => :catalina
    sha256 "1342f7668d6bfded20312f04dde6af08a9be7aac8b61fae3f76ee13be30abb8c" => :mojave
    sha256 "a8eaa8c7783e9e367490038bdc1344e3c0320cf07ef16c2ec7e8b47b93bd7912" => :high_sierra
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
