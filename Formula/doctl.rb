class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.92.1.tar.gz"
  sha256 "4d1b53ee473f4320fbbd834d364497acc31ba5dd5a4504d71c8b9eecfe9d76d6"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1777d9bda9c35dc09c059db9a5b0f3d9966f7a77ad71252db8491fc11b9b9743"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70f0b5c977e5c25e4c13c989bbda92e0f29ae640881624373c2041d3c7140c3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b132c8fced3231cfeb3eebca61db98e46bdee8124e407f7421bb69852afdcccc"
    sha256 cellar: :any_skip_relocation, ventura:        "faa0614ba9946ed908b10efa1f3d8ee0a737dc7621ad34add2c1c23c424b9b89"
    sha256 cellar: :any_skip_relocation, monterey:       "31bff45b94bb30dd7ed32b41bdd76ae76efc750e0fdf66e63397b6e225a1ebcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "13db26f493b66f72a68740d4ccebcaa59e46545a2038b5146d3ad834a96d1d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "484283f67a8dd50251c2b8049fd375ee590b1f4b5a57cea0dac539cf680c477a"
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
