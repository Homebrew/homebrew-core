class Ipatool < Formula
  desc "CLI tool for searching and downloading app packages from the iOS App Store"
  homepage "https://github.com/majd/ipatool"
  url "https://github.com/majd/ipatool/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "8f88d20bf971d6edbb8780cff8f76c1c565e9f352f21f6da0c6ac48003b3189d"
  license "MIT"
  head "https://github.com/majd/ipatool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c7205c6b97c913df9f784fa133da4feda0d35e4c89111b3af2f5e66d7440b3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91c330e959514d1773c09f8c3e8fa62aaf217033ea3cdd86b500fa8dfbda8815"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bbe18999a76a0264baf796c8489a29d522502daa3e19e1ca174282be9de83005"
    sha256 cellar: :any,                 arm64_linux:       "89fd51dcde6a8ee8831559b1e24d15f40050f6c062ea55c5c99e6ac8723319da"
    sha256 cellar: :any,                 x86_64_linux:      "7bc8e82eae2a086131fc5bfb36922edf077fbba95746a79648f95d7cdaf04533"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: "-X github.com/majd/ipatool/v2/cmd.version=#{version}")

    generate_completions_from_executable(bin/"ipatool", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipatool --version")

    output = shell_output("#{bin}/ipatool auth info 2>&1", 1)
    assert_match "failed to get account", output
  end
end
