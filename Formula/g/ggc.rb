class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v6.1.0.tar.gz"
  sha256 "1ef7d44372a184573a9197c57fb8a20b62db835fc11dfd6051be1b36763b02fe"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "809ec06ec7b524636bc6ce0f1af82f931e67c56a05fa0426e694df01aae064fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "809ec06ec7b524636bc6ce0f1af82f931e67c56a05fa0426e694df01aae064fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "809ec06ec7b524636bc6ce0f1af82f931e67c56a05fa0426e694df01aae064fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "57d0fd54da1c207aa177d9a0f4439585923397eff8b9db2d4622f2f351de42a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11236102723dcf5e280fd21703a18524e99ccc4163de70289c8e47f7a4761104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39d15ee0b6e3d5a818316f94bbf081f75d08e8f9d1601417700797a9d9522a3b"
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
