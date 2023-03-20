class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.4.9",
    revision: "18967282633144120abcf75a3dacc110543cc00c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3713acc5ba966da265f6296b6a6ca7629d14f7d7d7f25a8793b921d52eb18d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3713acc5ba966da265f6296b6a6ca7629d14f7d7d7f25a8793b921d52eb18d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3713acc5ba966da265f6296b6a6ca7629d14f7d7d7f25a8793b921d52eb18d9"
    sha256 cellar: :any_skip_relocation, ventura:        "406a54c1c1814c0df2ac6758ebe9058923fc712a2fe79d50fdc8544a538164b2"
    sha256 cellar: :any_skip_relocation, monterey:       "406a54c1c1814c0df2ac6758ebe9058923fc712a2fe79d50fdc8544a538164b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "406a54c1c1814c0df2ac6758ebe9058923fc712a2fe79d50fdc8544a538164b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67b151c4e18f77b929f159e9a18acfd655dac885121a79b438ee34fd44823b4b"
  end

  depends_on "go" => :build

  def install
    require "net/http"
    uri = URI("https://update.k3s.io/v1-release/channels")
    resp = Net::HTTP.get(uri)
    resp_json = JSON.parse(resp)
    k3s_version = resp_json["data"].find { |channel| channel["id"]=="stable" }["latest"].sub("+", "-")

    ldflags = %W[
      -s -w
      -X github.com/k3d-io/k3d/v#{version.major}/version.Version=v#{version}
      -X github.com/k3d-io/k3d/v#{version.major}/version.K3sVersion=#{k3s_version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k3d", "completion")
  end

  test do
    assert_match "k3d version v#{version}", shell_output("#{bin}/k3d version")
    # Either docker is not present or it is, where the command will fail in the first case.
    # In any case I wouldn't expect a cluster with name 6d6de430dbd8080d690758a4b5d57c86 to be present
    # (which is the md5sum of 'homebrew-failing-test')
    output = shell_output("#{bin}/k3d cluster get 6d6de430dbd8080d690758a4b5d57c86 2>&1", 1).split("\n").pop
    assert_match "No nodes found for given cluster", output
  end
end
