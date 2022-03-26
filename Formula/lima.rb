class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.9.2.tar.gz"
  sha256 "df0f84c7693e4f31ef40ccf209aaf034b96b3501ab2da8186c8857d372e5f0ea"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "980ed1038f56923a830b2016c14bb1693b3cfd483e4902b95b124e9c58b936b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e9819038a44a85734b55c7cf880797bf1f99ff672b0874c74e152e3640b4c9f"
    sha256 cellar: :any_skip_relocation, monterey:       "14ae542f9998529ed0952cef4c74ea6bd28a99fbe15655e81421dfc7964ec114"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfe45877c3777db3633c52967df098a5d6abcbe04ec0afa5f84fc112faf1d8a5"
    sha256 cellar: :any_skip_relocation, catalina:       "0d35c0b10d4892034f7a9717b239457b099aa35415e228fb5ae79f93012f21fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bde2974f9446d7a4ba2b7d3c3f9e6af74f3eff3d823c079bf0ea1bd6b00630e"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "binaries"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "bash")
    (bash_completion/"limactl").write output
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "zsh")
    (zsh_completion/"_limactl").write output
    output = Utils.safe_popen_read("#{bin}/limactl", "completion", "fish")
    (fish_completion/"limactl.fish").write output
  end

  test do
    assert_match "Pruning", shell_output("#{bin}/limactl prune 2>&1")
  end
end
