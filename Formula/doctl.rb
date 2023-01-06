class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.92.0.tar.gz"
  sha256 "0ecab3a37731722f1af5085429ce5c94402a8c665233e80f148570231bb16d5b"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6d2a11a240e28f8a853948d0155cdc82a9a24db81f9f1d14a44184515353f29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0cea9124cf0301baa25d1e7a9ab632aa0a9d14d1876b6b29b4c43663e841c7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "967672bd7cea9ec19748163ed6dab11a3cae94d4df7bcf86f95fbcd150ea3f92"
    sha256 cellar: :any_skip_relocation, ventura:        "fb42169dca9d6ee3874d495f31487b6abc580f5e61af32ca699fdfa4a7fd0a77"
    sha256 cellar: :any_skip_relocation, monterey:       "599272926ee3382bcc6247c6b0abc126c145b2491b188a1df71f0839ba332010"
    sha256 cellar: :any_skip_relocation, big_sur:        "83fa5a1ea93a243d550bbb9190ee40edbf30074d0ab159e71266717ef9b90ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e32b602f6b08127fb44abb9ea7b6601dceb8c564cce2219ff48f5df9b8466fdb"
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
