class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/v1.78.0.tar.gz"
  sha256 "8b2fb24f00b98db8f6a730cf8d7703b2e0b8fd0abe23cd1a64e325d4e8f49ffe"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "275a03e77351c4bde9341d35ac892ea22db3f2a771a80bfdea5e9b694021fa25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a64a4ba07916b930661d4996222fa5519dffd7f3bd055106b4f75666fea9f904"
    sha256 cellar: :any_skip_relocation, monterey:       "e51093b42102d697060cf2c3793b932d36c284d689330d85aa3847fccf208a48"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4ab63300b88ceb1e0478f1c9a19aebfc9395ae9c96915a6705143e69f58b273"
    sha256 cellar: :any_skip_relocation, catalina:       "502e6bd06232ef46b255cd6e1fb5a1f52a11b98d48f84f8c99ac3ffb52686256"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ad8061fde38b9712062644699f4b7f343d261b40d0d47920d4da375d8a3903c"
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
