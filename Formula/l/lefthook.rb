class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "eccaad2f63ddc809e3ba26ec15eacfb0b0d87623f83fd4d943c4d23557d5cadd"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1a2c988f63b25e6ca108b6bf01196076382f19701225cbdb11ba5282d13d5d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1a2c988f63b25e6ca108b6bf01196076382f19701225cbdb11ba5282d13d5d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1a2c988f63b25e6ca108b6bf01196076382f19701225cbdb11ba5282d13d5d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2e15402a0f4ef08436027a887b0e2145b39025375bef0d9dbbb8777ab79bc40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56ee91a624a997e411a787fc9946239b633d06fbefc6e5aa54fccbd99ab40227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77ad691e1f8e11640abc2ad6de376465bbbb58a127e92d51f78f0f64fe72e401"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "no_self_update")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_path_exists testpath/"lefthook.yml"
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
