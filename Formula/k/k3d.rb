class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d/archive/refs/tags/v5.6.3.tar.gz"
  sha256 "9cda377d81d20c2b059863d94f6cd94ce9299329d3239c91a25a926eb3202b0e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65cdda7b8a0e399f4a758734358a29e5bf305a3e8af2f2b3662fb058e2ead3a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1fec81f6b54b78b0af4c4651fa79f3ddc09161480dceaee1586d8a7b4775eb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecd17e101956b1b54726af1108cc798148ebf8fe7eb974bc9169ad4086ae0f3a"
    sha256 cellar: :any_skip_relocation, sonoma:         "61bf1aac4f19e01ab2c5dc06413b310183bd33cc38e1ac4369de974250aa68f8"
    sha256 cellar: :any_skip_relocation, ventura:        "e66884e7f5021bc48d6295992132ddd204d495b640176c3628c759a627d611f8"
    sha256 cellar: :any_skip_relocation, monterey:       "cbb390be99fe9f872afdb4548ccf3bf7a02980852f3b247d2e6e290a988656e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f1e0cd75c0b43f31363c865d0f96cc50d599fc513cfe0d623ca508fadaab5a1"
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
