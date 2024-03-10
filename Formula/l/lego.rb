class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.16.0.tar.gz"
  sha256 "174352f4075c09464ee2e9eb29bfd6141123631e79ea70d70a6fcc65c4ec803d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc0fa062e2da5461827a522ce9d0c7b8adba35c79059b7a70584b28f0a9ba0ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08eba0de59b1a6d51d382df492e27a5432ebc4232f15bd016828879193da4532"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02826efd3edac6ed6105d8860f1e530a12b41989bb92de437943ff02884f3ff1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c72b45e088e4bdaf200f60a5ef66b70b4a4d600ddb90c69fb59f5f46f262a8f"
    sha256 cellar: :any_skip_relocation, ventura:        "49122e5b729a8d950a10cbb294496baccd952ef46451c3554ddaa1435ceb094e"
    sha256 cellar: :any_skip_relocation, monterey:       "397f14458764630868b868203e675482eb5c5e4863a1563401988a861b610c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fb3815d142b3ee751f9e06de5761e5ed1c3ef8ab6061fea7da07e71b02b76a6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
