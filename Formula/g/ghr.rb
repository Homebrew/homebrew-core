class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  # homepage bug report, https://github.com/tcnksm/ghr/issues/168
  homepage "https://github.com/tcnksm/ghr"
  url "https://github.com/tcnksm/ghr/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "138a3a5e5c88268ff79cde69fd21c67af7c919d6b388da8e23f398f86871dbf8"
  license "MIT"
  head "https://github.com/tcnksm/ghr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b8957473cc4ea3216491e79993300d010894f70d88d10cdff50a4a13500718a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b8957473cc4ea3216491e79993300d010894f70d88d10cdff50a4a13500718a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b8957473cc4ea3216491e79993300d010894f70d88d10cdff50a4a13500718a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "22dd5bab0cbd02b7017703eadeff166b61d4d7c681f70816c81216b96115a8c3"
    sha256 cellar: :any,                 x86_64_linux:      "c97884cc0519bc001a679508f1edd89f6261b13dd192a9c37e7fde9e84f5480e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_includes "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
