class Mycorrhiza < Formula
  desc "Lightweight wiki engine with hierarchy support"
  homepage "https://mycorrhiza.wiki"
  url "https://github.com/bouncepaw/mycorrhiza/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "d3f462e022be6a68f8e40352db916d20adc0cb7ad63b11be53aebea369e22641"
  license "AGPL-3.0-only"
  head "https://github.com/bouncepaw/mycorrhiza.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10fb3f62b3843d6038d4a2690f2db7a2460ab5ac81190de5741bdcc9b42fadeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26e051274d418c3ecad2a33dddb66a480afe4929aaaf117e3500e1b9ba95126a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "544510f791a2074f9928d367b0b8e7d225cc55297f008db63a0f148f80415691"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfbfd105fb51097f6058c0c980218567d68cf007c0c672ed67bfae4a3ba1f77f"
    sha256 cellar: :any_skip_relocation, ventura:        "73baac7f89aa7825da2503eb52085b0f46bb5c8436f32d1ff6725c765f7bd2b7"
    sha256 cellar: :any_skip_relocation, monterey:       "bc7d2b0308aee0400c73e759d7a8e4954c10335a411d008f582bcc5ceebf83b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "414b068c11a93b31b08b0fffeef437801e17d8a20fe0ffc2bb0a58ed75193b15"
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
