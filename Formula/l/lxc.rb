class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/archive/refs/tags/lxd-6.10.2.tar.gz"
  sha256 "f30115cfa52e80c0129934da4bf37a7ad778528dd0fc1ddefaf4d111ff455d8e"
  license "AGPL-3.0-only"
  compatibility_version 1
  head "https://github.com/canonical/lxd.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lxd-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "117be75bc8dbbfee4beca8a6aa5cc89fb312accf93a6e6e38be9cd224eadc35e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d8079f7dd8a84daa0e65880b49b23836bb7466374ce97364031c7e684d50826"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d8079f7dd8a84daa0e65880b49b23836bb7466374ce97364031c7e684d50826"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4d8079f7dd8a84daa0e65880b49b23836bb7466374ce97364031c7e684d50826"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a4c38873af93fff3512d3680a432775a42dc84417776ac9648399baf1b10490f"
    sha256 cellar: :any,                 x86_64_linux:      "1a9cd54b9133bee897517920fc3ba493eddea408cfa2f8e3d5026a622e982822"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./lxc"

    generate_completions_from_executable(bin/"lxc", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases/", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
