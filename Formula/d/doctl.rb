class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.102.0.tar.gz"
  sha256 "e61067b57861bbac147bdf20a8cb5eb0537653057f978c1c06f5b5214d0b6571"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "583a6fb35e3ebab5c49f9e479cd0ea4a5e1d023563550b4e50337d9eead35ee8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e5f603920730f8383af0a336ceefcd8dc029507817b6eccb00716be4c353b59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "def0e4e5ce564d1fa93836238f71761a618e4836498f4a8c8631aa2178641a0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "062adc5bd831a6b6abb9cf3be557a8d65dee0ce041f2213b6a67c435f140d844"
    sha256 cellar: :any_skip_relocation, ventura:        "8741c3d24d671691155a4d717d1b5652154df3fa91aaa0f97db109585b9b2733"
    sha256 cellar: :any_skip_relocation, monterey:       "7be914a56668db5d0395d8c6767a7443c0555b8c5997ae8f51747de07671fa55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94f3c2a204ebba11165c2834d4067154147a7908b7b8260d03b85a64d3db2016"
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
