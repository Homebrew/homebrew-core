class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d.git",
    tag:      "v5.4.6",
    revision: "f6838597ddf1cab5bcdb391f883748c6e4d69b48"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "427e88513e325b9fadd3898a69d33a86b66256d56f088cbcf4064b4aecc2edee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "588d17cc7f9f064c55a39971ef17d19718bd7b0f96271a119e277372277c3175"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43ba3973c5ef2b3f7263a21593ad118676c0191b87bb4cda263567f8f44dab68"
    sha256 cellar: :any_skip_relocation, ventura:        "97db82d1247894a53d72ebe5e7c63840fba30f53730fbe1c40ace6c819ee9429"
    sha256 cellar: :any_skip_relocation, monterey:       "61056bb1b12548a2eebe84a69d25c2daee8b264af7c62f192903b320d27f7f00"
    sha256 cellar: :any_skip_relocation, big_sur:        "d52673edb9907ae737223b24e59d6285d28658b13f0f8fbb4c3bbb3162344709"
    sha256 cellar: :any_skip_relocation, catalina:       "83e7f2aaaf59b6454099d73ae4229bf04dfd7871e056e2956ecedafae9669395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d42eda8fc36ae8871f9cffffd09bca6a9357ee12f3dc42224c24a03fd7fd15d2"
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
