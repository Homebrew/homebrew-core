require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.4.3.tgz"
  sha256 "4fe9031c10e76303c729d339aa89f5c6d865d39ca3a0380e727bc790f3231d1b"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca194dc7e25d0e37c3c082a4fe2b0229db71cafddf0832d86b08a28d7f7f4318" => :catalina
    sha256 "80f6d859190166242df5fa8e14c8b6534772a3bc6d6eedd054a2acd34df38114" => :mojave
    sha256 "92f5f4278d08078b63ef62c5169617fa73cf13062e0023a6f46fd949175ec852" => :high_sierra
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
