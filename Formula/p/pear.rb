class Pear < Formula
  desc "Peer-to-peer application runtime"
  homepage "https://docs.pears.com"
  url "https://registry.npmjs.org/pear/-/pear-3.0.1.tgz"
  sha256 "a6b854f515c47245ffc03550df8122ee4ab9d999ae01b4ed16534b8c844c6e66"
  license "Apache-2.0"
  head "https://github.com/holepunchto/pear.git", branch: "main"

  depends_on "node" => :build

  def install
    system "npm", "ci", "--ignore-scripts"
    system "npm", "run", "make"

    bin.install "out/make/pear"
  end

  test do
    pear = testpath/"out/make/pear"
    pear.dirname.mkpath
    cp bin/"pear", pear

    result = JSON.parse(shell_output("#{pear} touch --json"))
    assert_equal "touch", result["cmd"]
    assert_equal "final", result["tag"]
    assert result.dig("data", "success")
    assert_match %r{\Apear://[a-z0-9]{52}\z}, result.dig("data", "link")
  ensure
    system pear, "sidecar", "shutdown" if pear&.exist?
  end
end
