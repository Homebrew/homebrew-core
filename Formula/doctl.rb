class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.84.1.tar.gz"
  sha256 "2df92ae3e46eb42d00167972452c36158bf459ab26f5c979fa5697097cf7ce41"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc0733f7576e0d5fde7ccd80c22689c41d891114ae22bbe0458dfee0e6a34605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "798bf889c0f0d3c19097fc35b93968381b0157b77b4c2f5f3c3c3ed91f3a9cbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b21f24d17d08569e97b6394a3b368dc6fea309e72a11d5993583cf1b75e61510"
    sha256 cellar: :any_skip_relocation, monterey:       "1afa9263f34e66e5e0e27695a5ba5b6ee698afd204ea1e585002c3a33e83ccba"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a13b53b2b64617e2151bbe48f33b926d0024c10319bef04da998b733472d91d"
    sha256 cellar: :any_skip_relocation, catalina:       "87716e69be3b39f0903f3bbe52f0d278d7f8c245eead468bfc5f9c38a79525cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "928fa8e15039c3055011b9327a4fa394b8dfa88cea8b59608dbeee7dc8613d8c"
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
