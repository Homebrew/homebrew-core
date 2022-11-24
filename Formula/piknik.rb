class Piknik < Formula
  desc "Copy/paste anything over the network"
  homepage "https://github.com/jedisct1/piknik"
  url "https://github.com/jedisct1/piknik/archive/0.10.1.tar.gz"
  sha256 "9172acb424d864ba3563bbdb0cd2307815129027eec1a6ca04aee17da7f936c2"
  license "BSD-2-Clause"
  head "https://github.com/jedisct1/piknik.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad21c6f5534120bf7b51f809e0441ed40d6c1647fd3df8ae5324f44b4b11d04f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b11a027946eda7b8937861f4458d6d0a8e320fb297fa44ea8a84883e5614b9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b503df3a16dfdf25219a598da5ae3c17676ee2367c0db0837403a6f728e4fcb4"
    sha256 cellar: :any_skip_relocation, ventura:        "6124866e63102b6c82103a39a6d6287ed0808648e619af94d8ef44df915e22c1"
    sha256 cellar: :any_skip_relocation, monterey:       "28f6e0672fa5745285ec63560821f35c6bf604fa42ad80828bd2ca70eb5d94df"
    sha256 cellar: :any_skip_relocation, big_sur:        "48b98419184b858ff308f4ed96f0ff001f757524c38705337a25adfb960a85ea"
    sha256 cellar: :any_skip_relocation, catalina:       "d454877b9f650eaa1fcd22ccad12c62a69d2ab21b48a16481d4be17067236233"
    sha256 cellar: :any_skip_relocation, mojave:         "8afe990d9ff9828b6148928d27c9535fd31b7f8082db341cf962dfbf1e895b96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d9a86776e5339217206d091bc5b37921db0c11c82b8a068108e41ef76c23fde"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
    (prefix/"etc/profile.d").install "zsh.aliases" => "piknik.sh"
  end

  def caveats
    <<~EOS
      In order to get convenient shell aliases, put something like this in #{shell_profile}:
        . #{etc}/profile.d/piknik.sh
    EOS
  end

  service do
    run [opt_bin/"piknik", "-server"]
  end

  test do
    conffile = testpath/"testconfig.toml"

    genkeys = shell_output("#{bin}/piknik -genkeys")
    lines = genkeys.lines.grep(/\s+=\s+/).map { |x| x.gsub(/\s+/, " ").gsub(/#.*/, "") }.uniq
    conffile.write lines.join("\n")
    pid = fork do
      exec "#{bin}/piknik", "-server", "-config", conffile
    end
    begin
      sleep 1
      IO.popen([{}, "#{bin}/piknik", "-config", conffile, "-copy"], "w+") do |p|
        p.write "test"
      end
      IO.popen([{}, "#{bin}/piknik", "-config", conffile, "-move"], "r") do |p|
        clipboard = p.read
        assert_equal clipboard, "test"
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
      conffile.unlink
    end
  end
end
