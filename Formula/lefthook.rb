class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "6a14d0354ba635c8fc188c351e59dbc057d61de3dc6a8d6a17fb4cecde260114"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "973faa1ea3c0a69abcaf8a15f095bcfd3bce9b057b6f4c3ee5e8d55dd0f981b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3ebc1cd8c8d296568ba15f3e8fd6978bac6e06dc4c971ffa206cf28dc6e9050"
    sha256 cellar: :any_skip_relocation, monterey:       "2b84b2c8b49ec898d677b6e71e8f8eee985f86aa4607591fc931e5a68244e4e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f956cfbfc7bc37a1dc6c48fb62bd90927a6ebc694f17b4e0983c6408c3cbe48"
    sha256 cellar: :any_skip_relocation, catalina:       "fbd174620b3c8107bbb0c2afcfd5692875344f71368205e5f81b6dfb60d159c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2887a9f988a9ea35ff6f12245afb99f79e5a56f19629a921fc7a9676bba53d91"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
