class Gotify < Formula
  desc "Command-line interface for pushing messages to gotify/server"
  homepage "https://github.com/gotify/cli"
  url "https://github.com/gotify/cli/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "e3b798d89138fdbc355a66d0fc2ca96676591366460f72c8f38b81365bebe5ba"
  license "MIT"
  head "https://github.com/gotify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b5118c65596ed810a05c95b3731c8c36a5a824dd7bfd380acb5f573944d13814"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd17f980e45205d7a3f690de4fe7992d555487acc023fa62e439f8222309307b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bf1e3860bb0d1a53948e4174fce8d13cf505f56e3409a3ece711cd769fa3acc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ab4cbb2a80a93e69b68e61ace5035653ad900319d01fe6399e4b2da8cfb440b"
    sha256 cellar: :any_skip_relocation, sonoma:         "40afcc3ea3466ac846ea96f3c765b7df3fc54a0a51751aad7b73d2a3a1e77201"
    sha256 cellar: :any_skip_relocation, ventura:        "0204c9cf61f9995f105044a97bef070f3d8b918f58d62c3a8a26b4d76319230a"
    sha256 cellar: :any_skip_relocation, monterey:       "93c7095233c6bf440ea8d4aa8005af752c54127f393e40b116a70c58c685f794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "815ef341c2802be6f1aca49fbd9a7fa040cd8e9971ccdb3df258e48cf67cafb5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}
                                       -X main.BuildDate=#{time.iso8601}
                                       -X main.Commit=N/A")
  end

  test do
    assert_match "token is not configured, run 'gotify init'",
      shell_output("#{bin}/gotify p test", 1)
  end
end
