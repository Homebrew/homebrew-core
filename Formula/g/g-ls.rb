class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https://g.equationzhao.space"
  url "https://github.com/Equationzhao/g/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "d65aa61ac4dfc300ac2b8ce79a8013272dfe6cc208afa8fb15be818f37392643"
  license "MIT"
  head "https://github.com/Equationzhao/g.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2fbb91ec0f0d6c0ce721cd1c70a7effc5d807601a363391a7584051a0a37a63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8259f659477fd31e5a3471924b80d72390cdbaa26e1a199c7fc72e42cc818653"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5705356a126008ab88b549b01c9e2d5efc6aeb69f8c5c95921d7014123d8fa7"
    sha256 cellar: :any_skip_relocation, sonoma:         "444759b8729285c99c9edf160332e3adc07ea513c1bcf2d3f7f240ed29fbbd29"
    sha256 cellar: :any_skip_relocation, ventura:        "7af79bc8b2b235b16d2c2628c6f05e7865156069f8f0df8a895e129d92924086"
    sha256 cellar: :any_skip_relocation, monterey:       "ea70052d92239bf49af46a93b3b4d05c99648c02d29da70ac28c282f4de93dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09400b19013882de679e96ada452d13bd7a901f2cdd5f2e5bbc5d53a2858058e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"g", ldflags: "-s -w")

    man1.install buildpath.glob("man/*.1.gz")
    zsh_completion.install "completions/zsh/_g"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/g -v")
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/g --no-config --hyperlink=never --color=never --no-icon .")
  end
end
