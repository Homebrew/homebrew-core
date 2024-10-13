class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "b4cd10f46ea2003236e7ff6632394bb7f2f6cedf13d2ee337203f551f9f663de"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72aed2f0c20b96855f52920bc9286f9360ec5fc9b14862011c817f8042569129"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72aed2f0c20b96855f52920bc9286f9360ec5fc9b14862011c817f8042569129"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72aed2f0c20b96855f52920bc9286f9360ec5fc9b14862011c817f8042569129"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb8d052696dcfb54d167d0684ca306d99bfc683ac7a8b12846e6031efd32e6a6"
    sha256 cellar: :any_skip_relocation, ventura:       "fb8d052696dcfb54d167d0684ca306d99bfc683ac7a8b12846e6031efd32e6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04de94ff65ce3ea2a8b8162a69a91279e9a887b72e3ca72d006fb7e756dfd290"
  end

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]
    ldflags << if build.head?
      "-X github.com/anycable/anycable-go/utils.sha=#{version.commit}"
    else
      "-X github.com/anycable/anycable-go/utils.version=#{version}"
    end

    system "go", "build", *std_go_args(ldflags:), "./cmd/anycable-go"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/anycable-go --port=#{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}/health")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
