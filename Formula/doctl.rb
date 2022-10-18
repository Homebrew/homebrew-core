class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.84.0.tar.gz"
  sha256 "63bf04ad2743932011b41e10f1de07b918c3e375c7632b69b859e8534b4379af"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cca06aa879a5d2216be6224252aefbd4a17b696dc13cc16aa6997397cb08194"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e55ec85ed3003574b70a11fda3d93589b3a2c9721636d11fbdd61eac2f11386"
    sha256 cellar: :any_skip_relocation, monterey:       "8acb0f603c445d1199571e0723925662b91cbb707792901e7d50eea1f3150d57"
    sha256 cellar: :any_skip_relocation, big_sur:        "36c8fa327f7aed9150aab263e581b07b502c6759738881d04fa7b183800c3b05"
    sha256 cellar: :any_skip_relocation, catalina:       "67c6a231fd43e5040e7fe7bf86fe61ef50b22bff8b9c03cbb102bc91733ac183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0345122fe365f4a4c3751c6005b851c3f064d33ae89c0d080e8f44ee7168133"
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
