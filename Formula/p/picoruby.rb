class Picoruby < Formula
  desc "Smallest Ruby implementation for microcontrollers"
  homepage "https://picoruby.org"
  url "https://github.com/picoruby/picoruby.git",
      tag:      "4.0.3",
      revision: "9429e1fe39281bbf6aacf1d603ccb4f67bf9b0bf"
  license "MIT"
  head "https://github.com/picoruby/picoruby.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7e167202bce693e8e990a77344a813e049e5c4092ec25c6683bb6c15c986fee7"
    sha256 cellar: :any, arm64_sequoia: "8ab4340ad4ea16af7517c37e2efc846ab245363012a266ffbc6cd2e523d95530"
    sha256 cellar: :any, arm64_sonoma:  "904f81c83f03a7ea320377f370d95293f22bd72c989db57de1b0c43c53e1cc96"
    sha256 cellar: :any, sonoma:        "23f659373a2f2b5bef50002659971924017b1b87c9503baddc12deb15257def4"
    sha256 cellar: :any, arm64_linux:   "6a77c47d05dc36370e430dfd6c5e029b7a971cc90f898c964e1d0891cf83e630"
    sha256 cellar: :any, x86_64_linux:  "fd94b60d1dcaed8f4d869df8ed36d9fd3f24dc2f0c7713f8ad1878b504660ad9"
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
