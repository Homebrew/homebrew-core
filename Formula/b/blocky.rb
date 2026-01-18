class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker for local network"
  homepage "https://0xerr0r.github.io/blocky/"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.28.2.tar.gz"
  sha256 "de4d677f2c3c718577124c3f6670bf209789b6be657138beb71a1fd1b991fced"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d1a28f1b4e0a0c32953ec333c4e72a28e052e8c43da3ac88db5f618c323c55a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ddad0c538df85aa61109ef085669e9fb871dcba3e935c298ccfda8ad2ae9969"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d427278d685e30db8022e766f3c6aba7290b98d6c8fc4946d7af7c294cb8ea09"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3fdef589a6698ffe7cc29b224de7abb1b4bc1e9d790ed8fb74d9ce26a1c6023"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34b540b6e9d524df7bcd37abe210b5df5906d77820744be1b6929fbf7a6d2a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bde9a0986261b181431f1eaaf6a33cc33ced73dd3280a89f36b229bf8836a54d"
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
