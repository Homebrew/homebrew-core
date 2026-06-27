class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://firefox-source-docs.mozilla.org/testing/geckodriver/"
  url "https://github.com/mozilla/geckodriver/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "713f2b3029b6b7af485450528164c6571df273d72de6009352c5c3c0c3211d8c"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4dfca2edf8a430c1123c63105cf0e3117ca50dd1ac8fe127c521de995f02c65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bead554258eff6b4d2524304cd35422cde072ac537d7dc4d8d5412c646767e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45fdb06f70e8e63df4568c22de843f46598eebaa3c4534fdc40bda8c24729bbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "3de88177363533d56200918cb12f01dbdd355d19ce0358ce8790d961d58885fb"
    sha256 cellar: :any,                 arm64_linux:   "4074b185fa69f7105513c1eb3a33be3b3138b5e76558c0e318e65b5e23839fec"
    sha256 cellar: :any,                 x86_64_linux:  "fbe5f5a88f1a060ab4df8932bf2ff54861b212b501728d4de65f0725c0051047"
  end

  depends_on "rust" => :build

  def install
    cd "testing/geckodriver" if build.head?
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    test_port = free_port
    pid = spawn bin/"geckodriver", "--port", test_port.to_s
    sleep 2

    # A functional test requires Firefox so we just make sure HTTP GET has a response
    assert_equal "HTTP method not allowed", shell_output("curl -s http://localhost:#{test_port}/session")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
