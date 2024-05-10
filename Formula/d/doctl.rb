class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.106.0.tar.gz"
  sha256 "d6149354d3be1800a8fa428c3702369c79afc196f4165c453c96ec3b6df2eb31"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2df0bebd05622698c46198c836c4726331acdb70839ff5dd864d8c570d3d9cf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01b6cbb9bb7eded7d3b92e2cea62b284090bc2a3a239a94122601dd0c811a919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee6295d57c27c1282f175bd62340bffe7141431c8054dacfa5ff6ecad416996d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec3f982dc2db6643e4de176e43af9212d0de94b3da90f58a0540f3dc7badc041"
    sha256 cellar: :any_skip_relocation, ventura:        "33668bf1a3d18ed09312c9ba841b2119f447f045a8f9813e9e8fbaa27a6dc916"
    sha256 cellar: :any_skip_relocation, monterey:       "293c3a76713fa0baf23edc337842c5f2fe7fb701744aa34d1ee770d6b961ece1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8d76b4048d2c3e97f7577d101b93a45c1a524a3c6ba81d489eba9fd290ecb32"
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
