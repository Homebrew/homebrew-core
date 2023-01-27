class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.5.1",
      revision: "d296259590bebf28c76e0946819b3b1f9bb851e1"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7af3cbd8c57c8e4f5de827fb930941311509cc3c81542205efddbc310ca866e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e0affab95a62d2d5bd91b6b5c8686a16aad03fab472a1978ac0ee9a25adefc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3624bedc3add6abb303688173efcde7f684b18830c8087f10486f59b0049985"
    sha256 cellar: :any_skip_relocation, ventura:        "0dd4656e50153413f04402b2b69a3e4687bb87681e0f03f7e5fbef45b80125b1"
    sha256 cellar: :any_skip_relocation, monterey:       "a232ec341572813a709ab75eae73e9e7a4faa3f896763f86ef24bfc49b9baeb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c14d09ede6d4fe64c935b339e468794cb5dee7795c643613363c7b2443c0e060"
    sha256 cellar: :any_skip_relocation, catalina:       "296ae9ec602ca43678def775ca4f76b41fef3b89bc905c9a0bbc80b1bef0ac0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2593c41ee98100fde005e703a6528ea16b7f8588681e2db13149260718946983"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags: ldflags)

    generate_completions_from_executable(bin/"fleet", "completion", base_name: "fleet")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
