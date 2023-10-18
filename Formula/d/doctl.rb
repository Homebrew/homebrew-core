class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.100.0.tar.gz"
  sha256 "ecfbcdb576271e79834ae28fe0cd7bcb29307f68f179de247af1a68015a755cd"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43a4dcf5944097cce3f4b4e7710bf2e011f38d257d763cca0492141d012d2101"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e5c0f5c5e4730dd38ee87890fdb14860e7397e695fde21cfbaa71793de68bdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49b516fd246954f2f250aee508bb885c70a107d069b1ca85828119339a609e6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1527a1101d5162e50a74accab4e4f760ed57ab15e6095fd8b0e3ce417b18769"
    sha256 cellar: :any_skip_relocation, ventura:        "f6146bb5779cdb89baa201641a0875202e07c836759166c204bf4c77a3b72220"
    sha256 cellar: :any_skip_relocation, monterey:       "8409f4a9349106095cab54e101c33d9a7cc2b61c63eabd99666cb5a895f18b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc6ac40577c7eba1851017250e79eb3b12220f1bf05f93605af3cec21924b11"
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
