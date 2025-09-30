class Proxyfor < Formula
  desc "Proxy CLI for capturing and inspecting HTTP(S) and WS(S) traffic"
  homepage "https://github.com/sigoden/proxyfor"
  url "https://github.com/sigoden/proxyfor/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f4e2340dbce232333ce05473b75f3b1eacf27d1699071b52a9cf420a8c47fd96"
  license any_of: ["Apache-2.0", "MIT"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "949fa8ba3a87e64a58c042fe41b28d8f81891b08436757a0fd43c55a8a7276b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6447af4607f2a07504be751324b5771f1db26846b5c4b426a11a615ba9b7487d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "312dae34b5b94992b9224e8eb2b38e11643ca63d2f8c3372544dcce1d39e4d49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a39e9bfc86def60ea447ea2e19b335aa72865762cc7eaa2b99275036664d7ff3"
    sha256 cellar: :any_skip_relocation, sonoma:        "60d4e3ed50f2cd2813b494a02be5386e9b41aade19c5ade38cfd9ecfeea0a6eb"
    sha256 cellar: :any_skip_relocation, ventura:       "30898aa6abea5af4799fefe20be28ab97cdb1a7492015ad68ee478b28b75af47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4b6723eea32a8a33afe29de95462553e9abbf58dcc0b7e944a6504f84b74031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88ea7fa84ae3d56bc167a24efa5aecd74e238bc22ba4fb618e0f68339c92a737"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxyfor --version")

    port = free_port

    require "pty"
    PTY.spawn "#{bin}/proxyfor --dump -l 127.0.0.1:#{port}" do |r, _w, pid|
      sleep 5
      system "curl -A 'HOMEBREW' -x http://127.0.0.1:#{port} http://brew.sh/ > /dev/null 2>&1"

      Process.kill("TERM", pid)

      output = ""
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end

      assert_match "# GET http://brew.sh/ 301", output
      assert_match "user-agent: HOMEBREW", output
    end
  end
end
