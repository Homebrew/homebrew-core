class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.93.1.tar.gz"
  sha256 "25474c2626cec226a36fd7e269b01b436aa0643d98f0bcd985faa1ba3feb8a27"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74e312042db64c2a2997eb06189413429e927ff8b896d4af41cf36a60b362718"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74e312042db64c2a2997eb06189413429e927ff8b896d4af41cf36a60b362718"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74e312042db64c2a2997eb06189413429e927ff8b896d4af41cf36a60b362718"
    sha256 cellar: :any_skip_relocation, ventura:        "4ea692069216865f33545425147f4eb719b7aec022a5eb2c3190f7d0a98d1dc0"
    sha256 cellar: :any_skip_relocation, monterey:       "4ea692069216865f33545425147f4eb719b7aec022a5eb2c3190f7d0a98d1dc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ea692069216865f33545425147f4eb719b7aec022a5eb2c3190f7d0a98d1dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb229b0ed53291236e71d75748d78c3b1d3f6c90f9d168d0454c3129f18f95c8"
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

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", "completion")
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
