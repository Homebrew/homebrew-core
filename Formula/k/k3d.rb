class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d/archive/refs/tags/v5.8.3.tar.gz"
  sha256 "2ef51e029f43e70dcda616de98980017ca7de18848265525bf7882d2bd66f9f2"
  license "MIT"
  head "https://github.com/k3d-io/k3d.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b39702101f971683bc8d18f279d29cb0ae60d3ca2699552745eb17b8c67aae7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227589aab818a49ba6c9238bbd924270a947991be82c54291246720726e15f76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "227589aab818a49ba6c9238bbd924270a947991be82c54291246720726e15f76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "227589aab818a49ba6c9238bbd924270a947991be82c54291246720726e15f76"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd519b1002c4600dfa993d201afed7f16e073052ae7e1ebb082a459a4fb1de69"
    sha256 cellar: :any_skip_relocation, ventura:       "fd519b1002c4600dfa993d201afed7f16e073052ae7e1ebb082a459a4fb1de69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55bf9698a5a0fa1d8cd90a5126d84ccdded8267b9479a73fae89a25b8e6c679f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "335ce09025bb68e0a22cc8d22fd89543345a2b6b485a7d6527ef356f7c109984"
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

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:)

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
