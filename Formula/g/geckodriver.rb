class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://firefox-source-docs.mozilla.org/testing/geckodriver/"
  url "https://github.com/mozilla/geckodriver/archive/refs/tags/v0.37.1.tar.gz"
  sha256 "57ee05afde1696bb094481150eebd93bf08af180292ab8368165cfb5f003788b"
  license "MPL-2.0"
  head "https://hg.mozilla.org/mozilla-central/", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c80513e266eed2909d701cf89e5ace3a30521bfb3642da7a42a61e7f73dc2bfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1baf9559ae4cce4f9153659c328c6537c6afc5edf785038dbc3803a516040fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e79c794aed820ead34113855b30eb3e14d2ff299af219ecee07f7aafd8181586"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8a73fd8291ca436ca001e0546dbb25053b0f3c59324e6088305ca4974ef63fd"
    sha256 cellar: :any,                 arm64_linux:   "928d11b364ba7573893c64f30f1386cb306260d279fef1adbac83c0c63b9ef94"
    sha256 cellar: :any,                 x86_64_linux:  "2a451dacce6b51284e34018a87e328002b43baef23c9f9dc7f1cc4737b3fd6af"
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
