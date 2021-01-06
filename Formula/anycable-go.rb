class AnycableGo < Formula
  desc "WebSocket server with action cable protocol"
  homepage "https://github.com/anycable/anycable-go"
  url "https://github.com/anycable/anycable-go/archive/v1.0.3.tar.gz"
  sha256 "8aa780b0ee5bf527fe211585aba2441a9cd5b72e58f353e3d4f76286262bf33a"
  license "MIT"
  head "https://github.com/anycable/anycable-go.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f41de1cc84bba5012e16fd2373b0f6db6781d5196506c6933a2e3eed7ff068c3" => :big_sur
    sha256 "a100c5990e3537d66f6225ab44fc22652a0c998210a56d36f839139d2c9d74e3" => :arm64_big_sur
    sha256 "dd4aad7525d8582e96f3d782b1f541bd12653b393a39b04d34b83401f007dff8" => :catalina
    sha256 "4584067882cb44c1af66c66e5730f040d6194ede81c6436d2622e3a2ddfae682" => :mojave
    sha256 "4c88aa03c10d9f6d45374d7fddcc4d6763790528567c332432f476a4eb05c314" => :high_sierra
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

    system "go", "build", "-mod=vendor", "-ldflags", ldflags.join(" "), *std_go_args,
                          "-v", "github.com/anycable/anycable-go/cmd/anycable-go"
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
