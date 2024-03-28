class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.104.0.tar.gz"
  sha256 "2a9827494c730cf663ebdb6f8b1e4f294366cf847e32ee0d9d274af3bac4bc1b"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "802bdec9e52a3f0308b3ff551daf6dabb18157b2a29f2b268c2924c33abfb2bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce005c52085a7d1e2609feee069040e3c7a252c0042ec356593cf61de68f2f4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f00663c803ab5900a2526dd8b2b7fc7c67f2b471d9be6b54f520293cfc64cb19"
    sha256 cellar: :any_skip_relocation, sonoma:         "92242285b3c86c9107160da0b9dcd878d6393bb1691076962bd24c93886d2e60"
    sha256 cellar: :any_skip_relocation, ventura:        "3f90e878032913d92a7535837bc94b649b4bafad703f96ebda99fdcc0890d9fb"
    sha256 cellar: :any_skip_relocation, monterey:       "7d87d4c2f47bd4bd67f94c8900e6c34f18ef3f08b9348e13088f05a20a6457ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e165f3551b4a091dde2c0294039c85d7abead3f86ee795fa79ed2a66decdf60"
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
