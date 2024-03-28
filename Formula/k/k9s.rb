class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.32.4",
      revision: "d3027c8f2916b23606f647f47b434b08fc34bdf8"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d424d36274b60bd09d990dedcbb545b4d8c6bb530d3f9d66c3a7dbf33ef5568"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28cecc07e880c1af196a8198ec24fb082510b6d9a5a3d053b60cb5ebd254aed0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee84d34293a7ce5990b966229f68439dcd836cef826e516628475b63d45f0526"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb09ea22822d3ebd325508c82c7ce03d22fc5bbf50c79badc314a1add84ac194"
    sha256 cellar: :any_skip_relocation, ventura:        "6da7494321cd1c95a962bb7c1574e4410587b818b19ac24d40049c8e23ef6893"
    sha256 cellar: :any_skip_relocation, monterey:       "78ed14ec6d891bed80303a9fdc7104ff8173b1c611b6ff0e120fb8eb63c64dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10ace44273e20be410dce5456010fabc3a5393229b5c4084fc7468fa5689e251"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
