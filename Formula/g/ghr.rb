class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  # homepage bug report, https://github.com/tcnksm/ghr/issues/168
  homepage "https://github.com/tcnksm/ghr"
  url "https://github.com/tcnksm/ghr/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "3524fcc2ba6874d393a1936d4c5b3b23c18fe2bdf453be15321b93ce0aa4c886"
  license "MIT"
  head "https://github.com/tcnksm/ghr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47ebdfabfeeba56f6c2ca3a9d4c998deba3cef8d28692f9d1ec37e8de4ecf51a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47ebdfabfeeba56f6c2ca3a9d4c998deba3cef8d28692f9d1ec37e8de4ecf51a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47ebdfabfeeba56f6c2ca3a9d4c998deba3cef8d28692f9d1ec37e8de4ecf51a"
    sha256 cellar: :any_skip_relocation, sonoma:        "129a6268818121ee71ad39d941430b27c420678e4ae17d935032f3ad9328abbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23f0a9bc9c07caa53b2076a2234e31b2c76a4b117464e83207b30f2ff47c3708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "276fafa40c5baca7202e3d451f4fe398fc65fcc136b06b02020f82c3499e8580"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_includes "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
