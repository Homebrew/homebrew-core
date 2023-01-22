class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker with many features"
  homepage "https://0xerr0r.github.io/blocky"
  url "https://github.com/0xerr0r/blocky/archive/refs/tags/v0.20.tar.gz"
  sha256 "aae5346e9c1ce4b326b9e578939aa26ddca39338d79d0ddb3eb079ae7a949e87"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "development"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/0xERR0R/blocky/util.Version=#{version}
      -X github.com/0xERR0R/blocky/util.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    sbin.install_symlink bin/"blocky"

    (var/"log").mkpath

    config_yml = if build.head?
      <<~EOF_HEAD
        # Reference the example config in the docs for all options
        # https://github.com/0xERR0R/blocky/blob/development/docs/config.yml
        ports:
          dns: "127.0.0.1:53,[::1]:53"
        upstream:
          default:
            - 1.1.1.1
            - 1.0.0.1
        bootstrapDns:
          - tcp+udp:1.1.1.1
          - https://1.1.1.1/dns-query
        log:
          level: warn
          format: text
          timestamp: true
          privacy: true
      EOF_HEAD
    else
      <<~EOF_STABLE
        # Reference the example config in the docs for all options
        # https://github.com/0xERR0R/blocky/blob/v0.20/docs/config.yml
        port: "127.0.0.1:53,[::1]:53"
        upstream:
          default:
            - 1.1.1.1
            - 1.0.0.1
        bootstrapDns: tcp+udp:1.1.1.1
        logLevel: warn
        logFormat: text
        logTimestamp: true
        logPrivacy: true
      EOF_STABLE
    end

    (etc/"blocky/config.yml").write config_yml
  end

  service do
    run [opt_sbin/"blocky", "--config", etc/"blocky/config.yml"]
    keep_alive true
    require_root true
    error_log_path var/"log/blocky.log"
    log_path var/"log/blocky.log"
  end

  test do
    # client
    assert_match "Version: #{version}", shell_output("#{bin}/blocky version")

    # server
    assert_match "NOT OK", shell_output("#{sbin}/blocky healthcheck", 1)
  end
end
