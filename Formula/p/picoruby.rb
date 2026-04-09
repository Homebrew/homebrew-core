class Picoruby < Formula
  desc "Smallest Ruby implementation for microcontrollers"
  homepage "https://picoruby.org"
  url "https://github.com/picoruby/picoruby.git",
      tag:      "3.4.5",
      revision: "d482862af826996fcaa65a42de5e6e51b6ed70c3"
  license "MIT"
  head "https://github.com/picoruby/picoruby.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b39a6e388fc4a4a8e07a9aba13ec4466ceebc47a91e3b163e56d426b9bf15ca"
    sha256 cellar: :any,                 arm64_sequoia: "69b10536c27a41bc94ab3356bdebbe24aeb97a2b91ae68064b37e769a5b5f9b8"
    sha256 cellar: :any,                 arm64_sonoma:  "a6138a218f7e78ec38e4f0da290b4358afac249a91d5e58fabaa33a114d7e3e7"
    sha256 cellar: :any,                 sonoma:        "9e960f3da3fd19199197782c8a9aa9d2d587f4cd85c415283a3bb1f204a40df6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d8b400847bdfb11d01c50db4b95b7acdc45c5968346749a22b4b3991e685b5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7272eaeff4e2e4782c4db9e2667a0d873e2da24e209b7b9f3cb5e6bab07d2701"
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
