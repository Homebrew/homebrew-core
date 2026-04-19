class CcConnect < Formula
  desc "Bridges local AI coding agents to messaging platforms"
  homepage "https://github.com/chenhg5/cc-connect"
  url "https://github.com/chenhg5/cc-connect/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "b4823bcdf34273b4699df20903d8d1feda9f7e7397b5ca62b76d1ca0a1996632"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35ae172ddc86df539c5de461497d589ff414768422c31c083a3f9d334513b5de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35ae172ddc86df539c5de461497d589ff414768422c31c083a3f9d334513b5de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35ae172ddc86df539c5de461497d589ff414768422c31c083a3f9d334513b5de"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9a43ab58390b3363a38e3740ae4d972fb57911c72d8b5fb32a2d9d49f4c5b29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4b05e1487613decdde3547cedee6eeb9f9946c6abb52c28b298694584e8fc9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aa953bf23a83cd8b1f936977349eb30461af89efdaaa3830263ca9691a540bb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildTime=#{time.iso8601}
    ]

    # Fix checksum mismatch: https://github.com/chenhg5/cc-connect/commit/92d4d81c205c346758170ac55bf17413fc47fd34
    # TODO: Remove on next release.
    inreplace "go.sum", "MEaUJLQJKFxTNo0xg+dKyOJA2Nu4O8kPVKuJ/gBiyjc=", "dRaEfpa2VI55EwlIW72hMRHdWouJeRF7TPYhI+AUQjk="
    system "go", "build", *std_go_args(ldflags:), "./cmd/cc-connect"

    pkgetc.install "config.example.toml" => "config.toml"
  end

  service do
    run opt_bin/"cc-connect"
    keep_alive true
    error_log_path var/"log/cc-connect.log"
    log_path var/"log/cc-connect.log"
  end

  test do
    assert_match "cc-connect #{version}", shell_output("#{bin}/cc-connect --version")

    (testpath/"config.toml").write <<~EOS
      [[projects]]
      name = "brew-project"

      [projects.agent]
      type = "claudecode"

      [projects.agent.options]
      work_dir = "#{testpath}"
      mode = "default"

      [[projects.platforms]]
      type = "discord"

      [projects.platforms.options]
      token = "MTk4NjIyNDgzNDcOTY3NDUxMg.G8vKqh.xxx..."
    EOS

    output = testpath/"output.txt"

    pid = spawn bin/"cc-connect", "--config", testpath/"config.toml", [:out, :err] => output.to_s
    sleep 1

    assert_match "failed to create agent", output.read
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
