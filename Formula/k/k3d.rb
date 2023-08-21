class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.5.2",
    revision: "a04aa84456d68d43ca56e11cf1e80d58b353ddf6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "850dcd8ce212d9f81673a5340c7d7c8548a882ee8b4106959224f1e309b80688"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "850dcd8ce212d9f81673a5340c7d7c8548a882ee8b4106959224f1e309b80688"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "850dcd8ce212d9f81673a5340c7d7c8548a882ee8b4106959224f1e309b80688"
    sha256 cellar: :any_skip_relocation, ventura:        "0c4433c5e6113e662769051afd9bd007f298ec29aade45855004a45d582fb5d0"
    sha256 cellar: :any_skip_relocation, monterey:       "0c4433c5e6113e662769051afd9bd007f298ec29aade45855004a45d582fb5d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c4433c5e6113e662769051afd9bd007f298ec29aade45855004a45d582fb5d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6f7e2b674fdec7b2c5b4d1929d6671dcaa135edfbc95a9296fba46938426d47"
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
