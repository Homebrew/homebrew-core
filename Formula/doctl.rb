class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.84.1.tar.gz"
  sha256 "2df92ae3e46eb42d00167972452c36158bf459ab26f5c979fa5697097cf7ce41"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "876a5436f35ee6cdae05df4c57ab702494f3df9c78ed7c43d1a5af1680601f4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f1f4f1674b57d8611727db9eb0081eeb96c44a9ee34f1a3e3ef8afcbf5d4dc6"
    sha256 cellar: :any_skip_relocation, monterey:       "5aaa21e18cad57b777f82fa714eaa771a9439db74285fdea61ee30c084f926b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b95351bd36b7bf352e05bef91a1d22ef3467d716b76a1e470ea99f1a310d8b4"
    sha256 cellar: :any_skip_relocation, catalina:       "04afbdb48f53ba61a7b2825144c8e9e75955e38ad411df69b3c2d254f6a8147d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8cce2a22a1af298f2430b26d89cc23ce4890b8c77741c46f35918b619dd4526"
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
