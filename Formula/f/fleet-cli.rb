class FleetCli < Formula
  desc "Manage large fleets of Kubernetes clusters"
  homepage "https://github.com/rancher/fleet"
  url "https://github.com/rancher/fleet.git",
      tag:      "v0.8.0",
      revision: "23e1c146755af159dafd3c88d4b92094772c99fc"
  license "Apache-2.0"
  head "https://github.com/rancher/fleet.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d983f6f57fbed653c79b1a16fe6221080abcf31f2e1b853dbd1cc8534ed916e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8d903156e240b12bb182b3e18c31bdcffccdf4158026f955ed9ddbb36194b63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ffdec2c6d54ce43c5cbb4aa183ef557ea637828c38f9c4d7da0683e19b8afed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "499ff70f541d13ad028753e0f8bd4eabd3b281ad96a72074bc1e3c7572b26c7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "548636a5669a614824c563961ad7a364d817143d52255969114d4b30cf3fa6f2"
    sha256 cellar: :any_skip_relocation, ventura:        "8f11675beabad67f72243eafbadaa0a12b67888dcc189ba950ea1c83f1e0e180"
    sha256 cellar: :any_skip_relocation, monterey:       "97e5ebb6b8c604dad59a89ca92d5ddeb7f6ca7c8524be15b4e80bed935c3bdf5"
    sha256 cellar: :any_skip_relocation, big_sur:        "db2c0f7183f1c07707cef37efbd679da78910018950e8806ca0d28e40a235b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "631b04127f7e76c2502a2400d9d34a9b87d1be1b3387f77257787d89ff64694b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/rancher/fleet/pkg/version.Version=#{version}
      -X github.com/rancher/fleet/pkg/version.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(output: bin/"fleet", ldflags: ldflags), "./cmd/fleetcli"

    generate_completions_from_executable(bin/"fleet", "completion", base_name: "fleet")
  end

  test do
    system "git", "clone", "https://github.com/rancher/fleet-examples"
    assert_match "kind: Deployment", shell_output("#{bin}/fleet test fleet-examples/simple 2>&1")
  end
end
