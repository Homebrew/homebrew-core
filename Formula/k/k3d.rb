class K3d < Formula
  desc "Little helper to run CNCF's k3s in Docker"
  homepage "https://k3d.io"
  url "https://github.com/k3d-io/k3d/archive/refs/tags/v5.9.0.tar.gz"
  sha256 "969cce82c4871bb829be798655abe2b6709b77cc0f42f7ff69293c621dfbbab0"
  license "MIT"
  head "https://github.com/k3d-io/k3d.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "507e196862ab3bf947ab40adfd7e8aa3b4b9d4c19c5efbea2ca7a3ac8d2f31e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "507e196862ab3bf947ab40adfd7e8aa3b4b9d4c19c5efbea2ca7a3ac8d2f31e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "507e196862ab3bf947ab40adfd7e8aa3b4b9d4c19c5efbea2ca7a3ac8d2f31e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "04b8420aa0d90fd24eced7168b80d7f7703e9fa61d5ba52110362c954b5b0be3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "950bcd988e70b7ca46c7aeb358c346dbde14e122484d5831849b305bbe38248d"
    sha256 cellar: :any,                 x86_64_linux:  "9c034896fcfd31ef193488171a8652fec9a865795fa4f357394bc60b13d58e3b"
  end

  depends_on "go" => :build

  def install
    require "net/http"
    uri = URI("https://update.k3s.io/v1-release/channels")
    resp = Net::HTTP.get(uri)
    resp_json = JSON.parse(resp)
    k3s_version = resp_json["data"].find { |channel| channel["id"]=="stable" }["latest"].sub("+", "-")
    raise "Invalid k3s version" unless k3s_version.match?(/\Av\d+\.\d+\.\d+-k3s\d+\z/)

    ldflags = %W[
      -s -w
      -X github.com/k3d-io/k3d/v#{version.major}/version.Version=v#{version}
      -X github.com/k3d-io/k3d/v#{version.major}/version.K3sVersion=#{k3s_version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k3d", shell_parameter_format: :cobra)
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
