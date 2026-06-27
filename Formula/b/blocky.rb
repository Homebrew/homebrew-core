class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "c61ef1b8e1ea194602be1cb617c8e6896f3a64c1226f877f20dd23bba46d695f"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f7a545548e5620a05613d6cbd23b3df9386013f7afdf99053b40c9b2bc1b174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "668e7efdd28d86d098b3c8f00b8dbfb74fe636bdfb27567159d127cfc18ad5ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4ca26b81557fb1ac33f7dfd0355b5309d593871f94da2c3a57540f729b0b59f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2361d210364d4c340903a673f7bd675ddbb5aa78126181269d6dc7e4f842488"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b5f5a869a9f0e48bafa72f8b495160c5c08f8a345c9d883fd2efeb2c79fe6b9"
    sha256 cellar: :any,                 x86_64_linux:  "d6b6c68c0544fc7c658d9d96d8a2716dffc4a1fdd1e544fd7e3cd3d89eb5980f"
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
