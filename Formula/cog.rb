class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "cec5ffaa559fdbeb8ebd79ce89d11781fece760d46cf33601c19eb7093deda54"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21af03e4d4bfab503b9c6e9fd7d2155189ae0a8c702e6a79893ba24bad4440ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9adce596ff5c30985eb65120b89d7192f6984bb4cbdb11b304f439d33a008e48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93596ce5af7a89e58d65e3454eff1cd497e0da93b4c70b75319e6a0fa3c1879e"
    sha256 cellar: :any_skip_relocation, ventura:        "6ba1edf0fa8a31ec5e955b141a16dcbfb6e0436d8e1425ed6d2e8400a6f95995"
    sha256 cellar: :any_skip_relocation, monterey:       "d7191d68ff46e12c06299f31644f7fff479dbcf73e731567ebf8260d3e27ce68"
    sha256 cellar: :any_skip_relocation, big_sur:        "afa8c52a7e5565b5416ab4e3496027043d4c84e6034b9c3eff088dc509a141a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b97fd3ac62dc7c9742556fc33b7bca75372492e60b1c6bf754e3cce42901c617"
  end

  depends_on "go" => :build
  depends_on "python@3.11" => :build
  depends_on "redis"

  def install
    args = %W[
      COG_VERSION=#{version}
      PYTHON=python3
    ]

    system "make", *args
    bin.install "cog"

    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end
