class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.111.0.tar.gz"
  sha256 "8bbb6c632f15338f2bd38124e6ee479bd39cee0779570762f776779db0132130"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "668c9ebcfd951e6f27bf48c59233a41fc8b9e18379fc6d8806b8c2a197e53cbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ab9ba388fad075ae12c4a7685b249320f5eef561e8d033ca55cb8db66507877"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b45c3c8585da63bb693e8d654ae8fdf1e194d0c215a967261379885d29417609"
    sha256 cellar: :any_skip_relocation, sonoma:         "daad9a2e908fcb188dda3aeddb1243ca2df82fbeb4885511cdc8d38b8536221e"
    sha256 cellar: :any_skip_relocation, ventura:        "e763f832aa29538c5bf587b34f02333c0e781344b7054fcf9ec4a8a616a2ab37"
    sha256 cellar: :any_skip_relocation, monterey:       "6c693f98feaecd069d3a3b4dae98ac08c195640afe40a23407ea8c7f5eefd6e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "787b92c50fb1fdbca3a1b1943f17036034de26630ca29a86de57014ace20a837"
  end

  depends_on "go" => :build

  def install
    base_flag = "-X github.com/digitalocean/doctl"
    ldflags = %W[
      #{base_flag}.Major=#{version.major}
      #{base_flag}.Minor=#{version.minor}
      #{base_flag}.Patch=#{version.patch}
      #{base_flag}.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
