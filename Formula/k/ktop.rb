class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "bd6671145897db1c0fb2016b16de49474b96f48cdf90385958beaf35b1a7f89f"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    manifest_sha256 "5c394e091dbf9252718f62d1d0943743e379cb31da371737bb4b9ce0f0ad32ec"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ae91415deefbb82ed09bfa3adff6094a60bbded11a4f1b52f49ffed5537fc9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7ddd93c10c479ded78eabc1ebfcd8cc9cfb73a1ad8f04d02b87816f86efeefd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17544421a01f11fd8a84a5e28399951346ec06d801e452b7e50f75482d851f66"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "954db1ed6973481b331cd6ac56c78138b2ec379a167e15792d31432154002831"
    sha256 cellar: :any,                 x86_64_linux:      "cfa5f77cc351b0bedcb10fc0f5ef2fdc7d045aa54d692e533ee957b3a7ef8b92"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/vladimirvivien/ktop/buildinfo.Version=#{version}
      -X github.com/vladimirvivien/ktop/buildinfo.GitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 3)
    assert_match "connection refused", output
  end
end
