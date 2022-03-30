class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.54.0.tar.gz"
  sha256 "b51bab13274420621e01e7143e7b88aa388aa370918ecd242b58c634ada94155"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "605246743fe823913efe81aab9022b2d21405300da929deb6ea81ed414a42ec1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2723cdc133f2e4d2887fc442570cca13aaf41560ce3aeed8d41df9223bc0cf31"
    sha256 cellar: :any_skip_relocation, monterey:       "ceac791a46f33187f9a545eacdb4145fdade7696310e8729e81f88fd79ac9d09"
    sha256 cellar: :any_skip_relocation, big_sur:        "51860ccf5e66a2e6ab48fb1b32219627d3d75550ef9b541d2a8d3e57149ac54a"
    sha256 cellar: :any_skip_relocation, catalina:       "eb720b92ce04fd2d74e4667469d18e92da6a7bbad833a191a1585d669378fb7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02184fef43221eac72ff614675608dc14ee9ba3704dc9009ef900da5e50902ee"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
