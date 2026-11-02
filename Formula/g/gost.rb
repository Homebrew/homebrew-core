class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "2c79c7675894cfd5849d646f037dc82e4278cd43439e3e0b0160fdf112269564"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "56dc532091b071220e49fec3f492adaee3676873ccbaa3fe7069dfdef1c8dac7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52c4479056b554b67c7ddd2b52bd0743a456d1dd01a4b640d2a5a87473b27ca2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "722a772e5f293d8ff19d0efdab1d4587a29dcd55cc63b4ce075233b2c4337caa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "068547dc78bfa25aea7c3ec768a23573d0afc9c24e128df12aa2f735176cac35"
    sha256 cellar: :any,                 x86_64_linux:      "878202ee41daa66441039fb93a7bb75a1aae2a764d812649001b2f7571c1c7a9"
  end

  depends_on "go" => :build

  conflicts_with "vulsio-gost", because: "both install `gost` binaries"

  # `test do` block runs a local proxy server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/gost"
    prefix.install "README_en.md"

    etc.install "gost.yml"
  end

  def caveats
    <<~EOS
      The config is installed to #{etc}/gost.yml.
    EOS
  end

  service do
    run [opt_bin/"gost", "-C", etc/"gost.yml"]
    keep_alive true
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    (testpath/"gost.yml").write <<~YAML
      services:
        - name: test
          addr: "#{bind_address}"
          handler:
            type: auto
          listener:
            type: tcp
    YAML
    pid = spawn bin/"gost", "-C", testpath/"gost.yml"
    sleep 2
    output = shell_output("curl --max-time 10 -I -x #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match(/Server: GitHub.com/i, output)

    output = shell_output("curl --max-time 10 -I --socks5-hostname #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match(/Server: GitHub.com/i, output)
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
