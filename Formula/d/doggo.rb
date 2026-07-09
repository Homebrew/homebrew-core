class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "ddea7da5f8e6263626ffbff57e3df5e84df4343a740b2f7a8dae2505aae645d9"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c27a8992a155bbb40488dd2e0edd3f24bf017ab3823636182e2914017e31df4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c27a8992a155bbb40488dd2e0edd3f24bf017ab3823636182e2914017e31df4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c27a8992a155bbb40488dd2e0edd3f24bf017ab3823636182e2914017e31df4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "aee4c24d881c0b314301487ee2102fc47f9fcfd90ce609cafdf9e6bf52f7fbba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e53d055595dd3c8d489df2f789ac081bb8ebebde43efca842028d939fb91bfd"
    sha256 cellar: :any,                 x86_64_linux:  "ac1a5ee3f873e292f60c4e33088036bbd93ddfc286175ed88ad4bdb41d5d20e9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    generate_completions_from_executable(bin/"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "hera.ns.cloudflare.com.\nelliott.ns.cloudflare.com.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
