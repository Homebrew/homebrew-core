class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  # homepage bug report, https://github.com/tcnksm/ghr/issues/168
  homepage "https://github.com/tcnksm/ghr"
  url "https://github.com/tcnksm/ghr/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "138a3a5e5c88268ff79cde69fd21c67af7c919d6b388da8e23f398f86871dbf8"
  license "MIT"
  head "https://github.com/tcnksm/ghr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ebbbe8bb5422b10ed67e8953469c6dbe26746f48cae356c1a9fb983dd58f82d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3ebbbe8bb5422b10ed67e8953469c6dbe26746f48cae356c1a9fb983dd58f82d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ebbbe8bb5422b10ed67e8953469c6dbe26746f48cae356c1a9fb983dd58f82d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f4f15fa52e06c484c9b8126a93cd38b669fd994f5086b9638f4688c37b6361ed"
    sha256 cellar: :any,                 x86_64_linux:      "1d8bdc9181ee529ecc04da326d9d049601159f253dbde4e79cfaaace5ddacb60"
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
