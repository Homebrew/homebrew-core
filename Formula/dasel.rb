class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v2.2.0.tar.gz"
  sha256 "7d64e3e6e37b358948ccd3479b54610b87fbcc562049ca96c0bcb4fcefeea350"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5d9ef50ac1f2d85ffc26039d64f3f626b81e3740ddd6a94620e4dd52f3699ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5d9ef50ac1f2d85ffc26039d64f3f626b81e3740ddd6a94620e4dd52f3699ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5d9ef50ac1f2d85ffc26039d64f3f626b81e3740ddd6a94620e4dd52f3699ca"
    sha256 cellar: :any_skip_relocation, ventura:        "2b3bcaa4050542e225b1cb5e944ec6d889ed5fc0027343647e69c23c6de851fc"
    sha256 cellar: :any_skip_relocation, monterey:       "2b3bcaa4050542e225b1cb5e944ec6d889ed5fc0027343647e69c23c6de851fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b3bcaa4050542e225b1cb5e944ec6d889ed5fc0027343647e69c23c6de851fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b14e11913c620ced39aa38fa5f854904301d11862d8b6a7f3df1cc3dfbcb586"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/v2/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel --version")
  end
end
