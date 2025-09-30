class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://github.com/vladimirvivien/ktop"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "ea3834ace7a60c6aa43eec18e53239df672d1bff0afba96c3f4564c6f334043f"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "252307b332540ba696c6505029238c94612545818e7e83e86bcc00377a26bf8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "027dd9fe6e8c9262a6f176f434ae26498d648e301228fb5175b3e14f8c38bdd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9bf858232d6da1e26d1b2a1c3686212d271699c9911559ed2ca3854b417e90b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c1af4cffda80d7b6912272713b2ea7f6d2ec8c0f8b88309a858b3d4d138d959"
    sha256 cellar: :any_skip_relocation, sonoma:        "80278e550005bf8f91466e8c2d35c5cb5ffe56ecdb52ca431406fa28c9c96307"
    sha256 cellar: :any_skip_relocation, ventura:       "32a5f021955cf7b35de292db2999852766058af5103e4aead50fe3b92dd2722a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60bc6e5ddbbbace74155a624d1aba80ef07e7757743ea367af8c53ab3fb42125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf02a77cf9e4d122b1006d5a60a4a1c182f7f5dc48ea1df7e2149c6c27c65faf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vladimirvivien/ktop/buildinfo.Version=#{version}
      -X github.com/vladimirvivien/ktop/buildinfo.GitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 1)
    assert_match "connection refused", output
  end
end
