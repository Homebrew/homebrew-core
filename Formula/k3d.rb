class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.4.8",
    revision: "5e5f56f7ec8f9be76bf301809f361ce6672d589d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70de9968bfe299fafd689ad73a306c2cd8b22cf5997de224ffd76e245305fc77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ad3e41baa5cdcee825c716a043f7e1324edc5875b9501d07158c4e8152b86e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5770041d0636fae5f3b370fc8fdbd51dd0f51032a3c8c97629c4822af00676a"
    sha256 cellar: :any_skip_relocation, ventura:        "2d21356473666c54aaee7436c91da157746e6b091f17475069c91233c573f40d"
    sha256 cellar: :any_skip_relocation, monterey:       "f1fa2be81ffbed9cf23a9f2258d539e87a5e2feec5177392683f4ecd6b9a363c"
    sha256 cellar: :any_skip_relocation, big_sur:        "740722dd62a2a36bb2eb3f657ed6aa25c01f4db0e41a64d1bbef65d4b351ae39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab6e8dbc60e972893a34168c37cda4e644aa1df0db72d4fd464e799bd1118b83"
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
