class Picoruby < Formula
  desc "Smallest Ruby implementation for microcontrollers"
  homepage "https://picoruby.org"
  url "https://github.com/picoruby/picoruby.git",
      tag:      "3.4.3",
      revision: "04587bbe8edc8f53df97e6e65228973c174982db"
  license "MIT"
  head "https://github.com/picoruby/picoruby.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c0b959d579ccd02283e3a85e48d978960bab223849a5e8d8ce5bfcbb6beae197"
    sha256 cellar: :any,                 arm64_sequoia: "f405aa5343d7cc6266a018a8984203554a60e1630dd0322371669a8ec4aacf8b"
    sha256 cellar: :any,                 arm64_sonoma:  "a9c32939321321aa0f6f18888349abc2fb37f07e8ac948f1443b4b3ac445e656"
    sha256 cellar: :any,                 sonoma:        "77a83c62f0a3845fb5e2c75d829ec1001d1a65742c89cf8d208cbdb4886ae3f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f537dec966c24f54b234edd1854edb59c4b4c3f4c94fc126c10d563b51373d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2770fe645257a1739d06f49c632c8bba23d9d06f794f883d783c85918bab9ec"
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
