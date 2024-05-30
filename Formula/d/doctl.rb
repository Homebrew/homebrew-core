class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.107.0.tar.gz"
  sha256 "2418f9e1aea35f5520e2069bac6cbdd0cae48b3e1cb8cfc077dc8de8d51e3af7"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ae1706d4f44295d196fb268e08f7d524a1c94167d5068e8060fbf76d8136990"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "121bbdcc07b433f98f03dd3ad8f4c0d3bab1d04d2d1d4d3703d1581bf644cfc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78635e17a5573dbd5d8d9918259b0093b13f0b103c5c0d873fcf48906930c70d"
    sha256 cellar: :any_skip_relocation, sonoma:         "c88c9ba07b5efaf0cf6ae65e3c9733e8a6dc0c6959afd1f870e14e6c786c958c"
    sha256 cellar: :any_skip_relocation, ventura:        "e1cf1ad33a0fb6593706029bc094720d5086d4a50f83a947e36f3dd67f382889"
    sha256 cellar: :any_skip_relocation, monterey:       "58e3851b5c7017a6f5b920d8317b41fe91eb69357c71dc7567cf03af5dbf473e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0fb0a18f67af5d0489ead9fa2bddd3e37178c6621951dbeb7cfa1a7e8d9fc5e"
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
