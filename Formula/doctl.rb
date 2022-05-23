class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.76.0.tar.gz"
  sha256 "b30704990c17e8a4f55b65814c8fb87ad3375b95123cbfdfc997b6a2012c98ac"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e293ff5065e9663bd40b5e7e0fea3c63548a51632c5239dc332b6e8b0ea2febb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9134a6b998af652334909842880aafabfa496124b509a390a3121ca50cffc66e"
    sha256 cellar: :any_skip_relocation, monterey:       "4f18b2d75262f0f4a9fee1a554d70d2b94bc8644e8b3c4782d149644b963cd8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "93ed294e003f37766490e8b2bfa940095ca205561f54a225f7674920935745ca"
    sha256 cellar: :any_skip_relocation, catalina:       "bb3959499898e0f64a3db5a4046e4df6630b9a02a70a83ce600ef80fba68cba6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "554dbbb1f403b3d37175682deeced57429c1b7cbd35ef6db2a40820fe2ea99e3"
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
