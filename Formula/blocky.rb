class Blocky < Formula
  desc "Fast and lightweight DNS proxy as ad-blocker with many features"
  homepage "https://0xerr0r.github.io/blocky"
  url "https://github.com//0xerr0r/blocky/archive/refs/tags/v0.20.tar.gz"
  sha256 "aae5346e9c1ce4b326b9e578939aa26ddca39338d79d0ddb3eb079ae7a949e87"
  license "Apache-2.0"
  head "https://github.com/0xerr0r/blocky.git", branch: "development"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-o", sbin/"blocky"

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
      EOF_STABLE
    end

    File.write "config.yml", config_yml

    (etc/"blocky").mkpath
    etc.install "config.yml" => "blocky/config.yml"
  end

  service do
    run [opt_sbin/"blocky", "--config", etc/"blocky/config.yml"]
    keep_alive true
    require_root true
  end

  test do
    system sbin/"blocky version"

    out = shell_output("#{sbin}/blocky healthcheck", 1)
    assert_match(/^NOT OK$/, out)
  end
end
