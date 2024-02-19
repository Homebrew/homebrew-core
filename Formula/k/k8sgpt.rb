class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.3.26.tar.gz"
  sha256 "9de7d3afffe3302ad5b96adbc7da11c7060f3e35f28046c10c308d4ab50b9d2f"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "641f5ade20c8a7cba3cd7d9fd545d713a754aa434065929ea3ab3f3273c92e89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "673b190e010d0dcb8344ffbc128f523da2e66f4132c3fc9d86b56c24a2a0a18a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b32e23165f8145d4437a7886e4ff31ee634b7905de83ff1c90ed99161207bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "4085c7e7c16dc403fcbd9ee884977c935fb7de50290362460b00a151db30aebf"
    sha256 cellar: :any_skip_relocation, ventura:        "89325d73d330b0ef5b161b52d62fc9680e03ed98a91d95d6fd1917e03dd29bad"
    sha256 cellar: :any_skip_relocation, monterey:       "88a0ccc0577971389c6d198b7d392b39663eeddcd85af36ceab43d34d9e364bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad827e559996090bdaedd81d4b4a573215b5120d100e7843f29f357c8dd7fba2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
