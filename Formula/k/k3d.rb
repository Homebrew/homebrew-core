class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.6.0",
    revision: "9748b1e158f3a03e807c6a989edc0fee856ff5a2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39af305ddee228c60eb25f53a1a80c546d3c98d2c611aa11f47d8eaed2cd1532"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73d02a1a5976a2762fc3c25bcc7db1f11006229bf717bd37e0570346a36beff0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10ea7c24365ec9fd476d65914ba3a12202f576398377f4142be927266ec5c454"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c9330e5348f29ed3c771725b88b238fb0170665c272c1124bf2c92fda10fab5"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa17e51e63aceecfe1f1949bb3af4b62d4e5fa154545ea3706caba896bd44125"
    sha256 cellar: :any_skip_relocation, ventura:        "5dc8f630f6359f16ecf22db39afaaee3a4b6932a367b33fdbc4cb63c61ccddea"
    sha256 cellar: :any_skip_relocation, monterey:       "f272bd80a863b995103aff56705abeec411c98d53ef90d215c046ffd41957d6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e888baaac7cbc22cdc927cd78beab0380f841316cb7314e323e07ac2ab88f522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a08089f31c6f1411f3d6aa63723e900abbd6a73da89b774c685abc2bbe88e32d"
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
