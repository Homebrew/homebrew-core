class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.8.1.tar.gz"
  sha256 "6a3a6ff38e02248cd6b8d992f05e0ff191ba271947d6a7bd89629e36870e5a57"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "04eb08c460bf9f09f0156be8469b76a2cda3df79f5aa4ca04987d84809ef83e4"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97402cbd449bf842822a99a99c44f13ac5e379cab808fb946f26313eb30cd87c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "97402cbd449bf842822a99a99c44f13ac5e379cab808fb946f26313eb30cd87c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97402cbd449bf842822a99a99c44f13ac5e379cab808fb946f26313eb30cd87c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4c1d8be431fd15c601e3a5f63dddea6470525f2d096dc7f736dbb84c656d008c"
    sha256 cellar: :any,                 x86_64_linux:      "b546cedf4e4d2d835a9c4581791cae56b49fc72e126cf2d212ab31cb0a5d8576"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1
    )
    assert_match "No account exists with the provided key", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
