class Mycorrhiza < Formula
  desc "Lightweight wiki engine with hierarchy support"
  homepage "https://mycorrhiza.wiki"
  url "https://github.com/bouncepaw/mycorrhiza/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "92b56606cb2e8b1afe086b86e68355a7aa6202bf77514ca6f07b32f7f143f4c4"
  license "AGPL-3.0-only"
  head "https://github.com/bouncepaw/mycorrhiza.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81f838895cc43b1735f72f67623c6ed551d6f522213b45ae2cb7da7031bd2bbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "239a63df7669042934cce4e4a36dac583b4f08ba351a7a2cc5a77d61ff2c71f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3c5d525c9adde1458160625aead01aaf7970eaa664a7fcd0eda201782f98f30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6a3e9bf597543fd047bcbd528fb294968626a43913e2b5ecb832e0a65c4f03f"
    sha256 cellar: :any_skip_relocation, sonoma:        "50902c67ef7688b2af218cb42a5e219d8b6ad1dbe73adb8eb5d4f9d7ce7ca1f2"
    sha256 cellar: :any_skip_relocation, ventura:       "babe0cd8e1a5328ee92a0ab611b8b1824e967857ac752295a6cd7ee658bb1ab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "195738a48e2c1462af8eb894c93c2691e7f4a186b86f0c1e6aaeb5da110a1782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7ac1d896d58f658da09c6590400fe8fe65a4ee61083bbe724a9a4705d0a6745"
  end

  depends_on "go" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  service do
    run [opt_bin/"mycorrhiza", var/"lib/mycorrhiza"]
    keep_alive true
    log_path var/"log/mycorrhiza.log"
    error_log_path var/"log/mycorrhiza.log"
  end

  test do
    # Find an available port
    port = free_port

    pid = fork do
      exec bin/"mycorrhiza", "-listen-addr", "127.0.0.1:#{port}", "."
    end

    # Wait for Mycorrhiza to start up
    sleep 5

    # Create a hypha
    cmd = "curl -siF'text=This is a test hypha.' 127.0.0.1:#{port}/upload-text/test_hypha"
    assert_match(/303 See Other/, shell_output(cmd))

    # Verify that it got created
    cmd = "curl -s 127.0.0.1:#{port}/hypha/test_hypha"
    assert_match(/This is a test hypha\./, shell_output(cmd))
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
