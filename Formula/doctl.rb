class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.87.0.tar.gz"
  sha256 "c4ec1bb03d5df9b6d321200f514b787e676d372add401773b6669936717b75ab"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8401a44c972e5272b33bc1004ba3fefd017d0312d5fadc444a0d27511f669815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aca15dc0f582fe1898189d014f21ce3bb5e8fbc6c3c1f9926a0d065fa7d5c69c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca7c65e3b9457a7d18f402d14848206c1c5945d4db2f5c4002613e95a46c9052"
    sha256 cellar: :any_skip_relocation, monterey:       "ad3bc8cb3b09b84e92b0269de8dcd111b61282fb1844f8102526632a0ad07049"
    sha256 cellar: :any_skip_relocation, big_sur:        "f91c8339fba7a351526ed71f4f4dff5c36c97c07a7f5f6b153b2d10ee111c5fa"
    sha256 cellar: :any_skip_relocation, catalina:       "92af900f9a8c4dad918c131b7857dffca4f782f8ea4ba4b3834c9e1a87d08234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9515ab7cefabc043d3bece95d56231d085f804c063824423942c85ac20bbed5a"
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
