class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.70.0.tar.gz"
  sha256 "527a0d02acb303ca3e55c28db162acbc018fb77ca9e77d9298fece2124774c32"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b337eb11ddce1016c2555699de61088d17efb9eaff28829bde664f309ca8b77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cddfd1b7963998e1a16c70a783be3e5a070ade9a7d1256e437eeb32984979ee3"
    sha256 cellar: :any_skip_relocation, monterey:       "5efb1a209cf0f28da7afea08944cd5c70b9acbd772fb0a6b522aecb68da64993"
    sha256 cellar: :any_skip_relocation, big_sur:        "1249fceae9b79e191104a6a0fdb11fd193b3efbd79b7623b3f983abe20c78737"
    sha256 cellar: :any_skip_relocation, catalina:       "a9f8bca2ba666c31603dae004ae525c0fa93110633bb1ada5fdf691eb4626a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bdb79a5e704c18b62d537e42ed5fac0e4aa24888e8c203190e09c6c04beaec4"
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

    (bash_completion/"doctl").write `#{bin}/doctl completion bash`
    (zsh_completion/"_doctl").write `#{bin}/doctl completion zsh`
    (fish_completion/"doctl.fish").write `#{bin}/doctl completion fish`
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
