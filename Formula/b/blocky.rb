class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "b6aadd53253fe51d1bd41a1c19911091b944657fd034cd3dfad8c139ac5870b3"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98de841022b35ce277c2b1193bb5989061cc65a4aee83ea5f87f5bd067640c03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "883392b4a72e8036338af0ba00278c38dc81447f26c50b72039773e1993845f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31fd03e5e27134526e51d1a46e5a8c49b876a05b55fd5465cd692c26946a588f"
    sha256 cellar: :any_skip_relocation, sonoma:        "442b143495141b70f31ac4371fd6b14490417aeb6c216bc9ccc971a557e42ef6"
    sha256 cellar: :any_skip_relocation, ventura:       "5460f7ce1fdb2f0c2a6b38df5d99078c725548ff2c6ca54bd39bb8da7bc5cf18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a2f4857199ef4cdbc53feee624a863b306c50b2fbf4f9d5b4d87f3f943943a1"
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
