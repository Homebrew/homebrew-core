class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.90.0.tar.gz"
  sha256 "4c53d56baf2be785f916fcc9b8f7afdd9b85b0987130de880cba1b86abe7e1e3"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "581ef184d4dc90d40f52f36e6fcb24dfec1483dd0cae886f7f36af1ec033045e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0734bf175d1383c715b277cb78761e417fe62980d3e59eb1d538066939793e2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f01ccbbc2e86492cd521ed8179cb89fac8ae615460f5871fd65076eb4d3c974"
    sha256 cellar: :any_skip_relocation, ventura:        "a2bc93f0fb3221041fb72410d620bb28ab99f92d74c0e7806d2cdb4b0a90bd34"
    sha256 cellar: :any_skip_relocation, monterey:       "14bc31d8ae4797c998e09edca6b87bd668e4bdcbae410619d7f937f21055ed7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "eeeeec6b22157c981d749107e38fff3041ea57edb74f71f67800b7e365db96a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4908e52e30a22a209cb5c889b9cf2ca802dbc662e7c70d9434d3bbd8ec8c1b7"
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
