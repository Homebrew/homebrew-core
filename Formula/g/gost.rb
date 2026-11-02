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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "adb13bfc76e0932f92b344d81f0fd9f18fb6a82be3b379ec0e0d25010e7af6c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a3c880db2b207ada8a3a51e779a8a0e6e65c9d8d84da87882cf1fd131e40446"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8cfbc2edcf33ba62ec935dbca0d208a7b45c8f3032f59c2f2308ca9d7e584b6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1056c80d076fac6995eba1182fe7ec52c962e651b8d7b2f83fe903ec3895ba06"
    sha256 cellar: :any,                 x86_64_linux:      "37493978bcad3e7350b8c294472ef8445fcedd3806e6fa5f016011044e7e828a"
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
