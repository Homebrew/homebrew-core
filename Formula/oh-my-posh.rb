class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.22.0.tar.gz"
  sha256 "07a9fbd9531f29dee92b3e92321083d505e071477b550c2f2a2f8928fdecad05"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52364399e7737cec6ecabdca975a80a94d70b93ef3303255cab465f4ad1ec2a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e023d62cb49fd47f28138d1b8e8d13a17a53971b54c3dc9b3eb80138035d7e68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24464ec0a2cbdfb8067ff380e8247ef217ea1fbfab2cb7ed6a041764e64084fd"
    sha256 cellar: :any_skip_relocation, ventura:        "1824fcc1294585f7c38d6f3cd33a39ea2980573d3967f9e098f2c61722779ce4"
    sha256 cellar: :any_skip_relocation, monterey:       "0c1b7b31d9be90f2f3d6ce71009f9d34e766c4b438173ae4a403270dd10605b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "05866823124451cfa9145419fce9f8ffed8fd8f2ee3ea0e10dacb0d002dbacaa"
    sha256 cellar: :any_skip_relocation, catalina:       "f425c072bf70d665bb4148eb45629e552c0876c5f5cf77e7145b53a8bca12206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1696fc422f779db0da051c3f20bb3408696957c675aa7fec96254e06eec19411"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
