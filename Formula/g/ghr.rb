class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  # homepage bug report, https://github.com/tcnksm/ghr/issues/168
  homepage "https://github.com/tcnksm/ghr"
  url "https://github.com/tcnksm/ghr/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "d95ef0cb78ec9f137c40cadaf2e8ba8858fb495399122abd44ff0b9a82ffd48f"
  license "MIT"
  head "https://github.com/tcnksm/ghr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6533f8d9e2a629e2d66963783d9307e8f4100687c7c5f6542b701162ad407111"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6533f8d9e2a629e2d66963783d9307e8f4100687c7c5f6542b701162ad407111"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6533f8d9e2a629e2d66963783d9307e8f4100687c7c5f6542b701162ad407111"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0581d1a0ecf05747c553bf32a6a937e82e9f22ac917f0e95a37f18daae80dc43"
    sha256 cellar: :any,                 x86_64_linux:      "503d91b64c5920578da8333c1aac512a47426f2ab6dbcf513ab8acf95b8c0cd5"
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
