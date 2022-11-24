class ChainBench < Formula
  desc "Software supply chain auditing tool based on CIS benchmark"
  homepage "https://github.com/aquasecurity/chain-bench"
  url "https://github.com/aquasecurity/chain-bench/archive/v0.1.7.tar.gz"
  sha256 "bc42551bde3ce61500d0eea3f4443e29bc2c5d86b1f01e87f929c46ce308ca9a"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/chain-bench.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "997209311ff1af7648a4f84f43258fa0d9e82c97fdfe82dce63cfd9e62563130"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "000b4b2b1a4c6407ec4c6b420fafa70b5a26318246dd2aa6ed029316c745296f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15b481b75553ea413fc1908f768dc6799ef5e49ecb544224c98ab2c391ec8ca2"
    sha256 cellar: :any_skip_relocation, ventura:        "44f7b9f50cb6582af6896268b509055a086d6841ba0064eeeaa959a908d3d4cc"
    sha256 cellar: :any_skip_relocation, monterey:       "39f705e5598ef3ca853cc489c666b8a9cea8c0fd17a5cef9d6f912855ff31604"
    sha256 cellar: :any_skip_relocation, big_sur:        "70cfcbfa2c38b88762131b9cd3fa880191f2e21043507f13d0a0762217be2531"
    sha256 cellar: :any_skip_relocation, catalina:       "4488882a383b954872eaf5f85e0a06e941d7bd339665e73d946bbb1053daf8f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba0d7b9d85346074ae4ce41a8e5b3f764b3f027ef740ec79b6d86408867fd96"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/chain-bench"

    generate_completions_from_executable(bin/"chain-bench", "completion")
  end

  test do
    assert_match("Fetch Starting", shell_output("#{bin}/chain-bench scan", 1))

    assert_match version.to_s, shell_output("#{bin}/chain-bench --version")
  end
end
