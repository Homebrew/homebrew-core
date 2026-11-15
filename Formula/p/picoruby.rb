class Picoruby < Formula
  desc "Smallest Ruby implementation for microcontrollers"
  homepage "https://picoruby.org"
  url "https://github.com/picoruby/picoruby.git",
      tag:      "4.0.5",
      revision: "604666ec366bd9c597756e3d671bfa4c378f165d"
  license "MIT"
  head "https://github.com/picoruby/picoruby.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d9e6b1683906d6780b22fc60329b3a7506134624d9a3006a507b51d4cc1f7baa"
    sha256 cellar: :any, arm64_tahoe:       "6927124044346dd746515773ff8487cff8b8c4752b9ebaebd713163f74867377"
    sha256 cellar: :any, arm64_sequoia:     "7192567af2a309905edbeac4324758a235a91f212880aa164540e79187c020fe"
    sha256 cellar: :any, arm64_linux:       "832cd04b8e20e0317796605ddac31d7a3ec04d8dd9a22b008d06dfbb40979e34"
    sha256 cellar: :any, x86_64_linux:      "028242ac84c0436b41e8b18539482180196e2db476edd60303d354d9349c98da"
  end

  depends_on "ruby" => :build # for numbered block parameter `_1'
  depends_on "openssl@4"

  deny_network_access!

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
