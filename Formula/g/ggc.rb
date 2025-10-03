class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v7.0.1.tar.gz"
  sha256 "3cf10e9d009b008f0730f72583d291b5b6a9c3672de018065b828266aeb86758"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40482d63bbbef70d86c68d28c0096f9593a8898280617d2ec0c22d66eacd56e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40482d63bbbef70d86c68d28c0096f9593a8898280617d2ec0c22d66eacd56e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40482d63bbbef70d86c68d28c0096f9593a8898280617d2ec0c22d66eacd56e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "14718680571a87f7e951e2816398370abbfbebe5227267a6b31b4ea44ca6295e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80c4096165d073d7a09db61cca5482dc1cfee447f9202a3edd26cebcb3e23c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "427f1a767b44aa0638e9f3b1766460aa24cb33e81dd69a7e98a928474f9fb8c1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")

    # `vim` not found in `PATH`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
