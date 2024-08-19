class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d/archive/refs/tags/v5.7.3.tar.gz"
  sha256 "871b46e3b2857c18372d5d5fd231a4a09f1693fc0350ab3cb2c6587751b12f41"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d71e3352f68f926f307af03a0567f5c452fffa64e3e367211606a40014e63e38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89c133a3938829737ccf38a112a47cb02ab0ddd66b72ae63c04c5c6a447b00ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "778f82fc4cbd93ba802478d5b84dc952d7da6f81ff1961ffecf76033347e53cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f9f7ce73dc11dc99a91eced65a8ada4cb95711fc0568834d99026b7bc643878"
    sha256 cellar: :any_skip_relocation, ventura:        "263e5fda93d1ebb5c5569cf0a10071561b6419e043e60eb089a063833a483a91"
    sha256 cellar: :any_skip_relocation, monterey:       "fb9eef93d436101507050faf40c904d4b80d7691a733d1d16a468aa75ef259d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c22774259a25e3bf208ac34373c06ee7a91853561e3a07ea5eb82a52772ca32d"
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
