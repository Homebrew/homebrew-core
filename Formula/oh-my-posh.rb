class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.34.0.tar.gz"
  sha256 "f7bf70724bb0e1e04ea337177beb8e54221c513f8ccbd10503998a882e41a88f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95191b5cce98c1a4522e9223652fe2271c81485e1d3cf5123dcae2d6f315b588"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "026783eedeb5120d5b698285dbc21b63cf1d4971ffea56628c6d55b6e17baace"
    sha256 cellar: :any_skip_relocation, monterey:       "85de034a652316170b55e324852d511fdb844b52194b92824cf94b9b65285399"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfe81d86058a9c24fd15064505a89349ec70644c8856789941e51e5fe119d281"
    sha256 cellar: :any_skip_relocation, catalina:       "9855ca459bc673faef55fc09651c93c20c1051277a819a6137578b48796cfb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d433d18fadb1a11409e8e8d5b069806b5e75c417c01a028926855af68d19674d"
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
