class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "b51b5a23727c1f74f976204524c77d571329439eb88c9a718b92916c16c93ca7"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83a890a2c9ffeab8d71c99e9dadb4f7ecf5445fffe665c35a6b4fa4b5970dac3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8230ac7a9343edf2966cf52a1cc0d95738214e41a84fc270fcb83870ba73f266"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5093e8cd1ef61857646dd3076ed5497cee1fcf6cbba4c98bc8ec7b01b7e528df"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c272fd2d366cbd9b552c9a18895413367ec2d5e2133eeeedf58692cf13990aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98d8883a392f68ad7eea23bd84c99f369e1432147ab9d0822f38de7d572c1694"
    sha256 cellar: :any,                 x86_64_linux:  "4e1382de87d66c7d39a036f1ee0e71a00230169c41dadae8efeb6d3f04aa2018"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/0xERR0R/blocky/util.Version=#{version}
      -X github.com/0xERR0R/blocky/util.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: sbin/"blocky")

    pkgetc.install "docs/config.yml"

    generate_completions_from_executable(sbin/"blocky", shell_parameter_format: :cobra)
  end

  service do
    run [opt_sbin/"blocky", "--config", etc/"blocky/config.yml"]
    keep_alive true
    require_root true
  end

  test do
    # client
    assert_match "Version: #{version}", shell_output("#{sbin}/blocky version")

    # server
    assert_match "NOT OK", shell_output("#{sbin}/blocky healthcheck", 1)
  end
end
