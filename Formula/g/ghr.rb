class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  # homepage bug report, https://github.com/tcnksm/ghr/issues/168
  homepage "https://github.com/tcnksm/ghr"
  url "https://github.com/tcnksm/ghr/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "3880f783dc9bded96d67bd3138a283eea8da767559ca8ae904b316965315199a"
  license "MIT"
  head "https://github.com/tcnksm/ghr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbd3282a88b2429f5a5c12b6ae0083f141f8a8003c7e104e735fec5a41740d4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33eb8a6c60098a3b5f4c8f86fa0362c33a96d9666c2f9327f2af05822c40ad72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33eb8a6c60098a3b5f4c8f86fa0362c33a96d9666c2f9327f2af05822c40ad72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33eb8a6c60098a3b5f4c8f86fa0362c33a96d9666c2f9327f2af05822c40ad72"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e520a3a2a2fbdeed8ccc62df3d69a9aebd712ecdcd7895badb0d2894f6b0278"
    sha256 cellar: :any_skip_relocation, ventura:       "5e520a3a2a2fbdeed8ccc62df3d69a9aebd712ecdcd7895badb0d2894f6b0278"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31f11960187e900d2bad217c81ed8e29a59ab1c772fde3943ced1b4c699fdd87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62cc14affe982f4b63fe94b4e71d39c3cc4235dd66e6a91294e0b7487ba70de2"
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
