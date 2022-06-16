class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.77.0.tar.gz"
  sha256 "56514dd2d50d74703aef2c184127804e1b08ff2216130125bd066255ebe3220e"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24bfa5b8e659fa3346073319fe1c4b3b4c21c7e6795e0fce4a6152d6fb2e7016"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36d56805a3edd6d73d7ad3833829962a80536466345db0b57e77f75804a9c0d5"
    sha256 cellar: :any_skip_relocation, monterey:       "a45f733a890e26eae89a1d6dfd1c1cdc099b3bab18cf5f4ef5f52cb736dde8ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e244d78824dafd8ec7ab9c9dfeeaec1ce4dd2005c50bea05ccf7cd577c64a18"
    sha256 cellar: :any_skip_relocation, catalina:       "3cb6347f1d5716693a03cb60d003af83f3144acf407cfa224ea96bb7c082fbbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f76c8b1cfa161b854acdee49b914edd15e1a5d3ab9175a36e295d0852afb8275"
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
