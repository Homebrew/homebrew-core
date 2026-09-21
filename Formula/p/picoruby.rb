class Picoruby < Formula
  desc "Smallest Ruby implementation for microcontrollers"
  homepage "https://picoruby.org"
  url "https://github.com/picoruby/picoruby.git",
      tag:      "4.0.4",
      revision: "c4e8c3f8926b28faf297d982075721e64078dca0"
  license "MIT"
  head "https://github.com/picoruby/picoruby.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e7a1c312226e6c04c9f1e99df13eb08cfe7b69f31d3962a309f7e34a51f5e62e"
    sha256 cellar: :any, arm64_tahoe:       "24b5a0a92db1046a3b0525b91238648fb90c0f3ddeac45f1507a1fa148a0658a"
    sha256 cellar: :any, arm64_sequoia:     "0748b083bb0b0c212c3e18e1032e7b4e5b84adf4fd937b1b5fefc56492de7dfa"
    sha256 cellar: :any, arm64_linux:       "9cb24583c4974f5d350c726b226529716a94dd73296e4a007056e80580cfe09e"
    sha256 cellar: :any, x86_64_linux:      "7fc52af3158b3fca76ed93328722b55690a687dfdd65b498e44b756c7d567768"
  end

  depends_on "ruby" => :build # for numbered block parameter `_1'
  depends_on "openssl@3"

  def install
    ENV["MRUBY_CONFIG"] = buildpath/"build_config/default.rb"
    system "rake"
    bin.install Dir["build/host/bin/*"]
    lib.install Dir["build/host/lib/*"]
    include.install Dir["include/*"]
  end

  test do
    output = shell_output("#{bin}/picoruby -e \"puts 'Hello, PicoRuby!'\"")
    assert_match "Hello, PicoRuby!", output
  end
end
