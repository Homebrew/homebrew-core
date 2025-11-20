class Invoice < Formula
  desc "Command-line invoice generator"
  homepage "https://github.com/maaslalani/invoice"
  url "https://github.com/maaslalani/invoice/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f34f20f6491f42c0e94dbde433a578f0dba98938f2e3186018d3e16d050abdaf"
  license "MIT"
  head "https://github.com/maaslalani/invoice.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b184af5ef239ded049ef736a7fd0b38166830eb48a68069ec2c087cd832f3a60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "57ae38669eb66909d476bf260857c15657b1a9934645adb5ec339fb6d56eb07f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfd3dde3902f66423f1a09b951ad977729e31b6e7b81e5e6f4f61de4765e438a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f60846fa811e66cbd42acd1d900081f5029a492c8b5959983faa333409a3207"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56261fe54c7a9268a1405a62d6b61f7a7ad1249ee4630d0c61ee3043db1db457"
    sha256 cellar: :any_skip_relocation, sonoma:         "9998524c8a3e9e2eb17ddf71de7290230b3f1caa7f37ef1398beaed2908da774"
    sha256 cellar: :any_skip_relocation, ventura:        "f4f343dc13b544093113964003344450c555714b286bb4be8049bf7dacd747f7"
    sha256 cellar: :any_skip_relocation, monterey:       "8c2382bc80db909ed4d6e4ad929f31b8a042545fe0c822b0247197d6c7afa756"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "529e6844604ba6c0a311e74540468d0e79c6a161959d2fef833659c1e834bfe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc46d1f1aba2274b4f41c09a95b9beed529e456ecb3c0d8fe8f0f7f0246bc616"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    cmd = "#{bin}/invoice generate --from \"Dream, Inc.\" --to \"Imagine, Inc.\" " \
          "--item \"Rubber Duck\" --quantity 2 --rate 25 " \
          "--tax 0.13 --discount 0.15 " \
          "--note \"For debugging purposes.\""
    assert_equal "Generated invoice.pdf", shell_output(cmd).chomp
    assert_path_exists testpath/"invoice.pdf"
  end
end
