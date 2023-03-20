class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "6bd07dd4384c196fab52160476f6e657e56d1154b71c3cc2f730bdfcfe2b2c15"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d21470a7f4c683ade66429f211fa7390f8336edd6d1ed448af264f4166743dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d21470a7f4c683ade66429f211fa7390f8336edd6d1ed448af264f4166743dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d21470a7f4c683ade66429f211fa7390f8336edd6d1ed448af264f4166743dd"
    sha256 cellar: :any_skip_relocation, ventura:        "c903af9572e0d84dac638d83f79bde19e68906314a0a3c3f9386463e67cfd85a"
    sha256 cellar: :any_skip_relocation, monterey:       "c903af9572e0d84dac638d83f79bde19e68906314a0a3c3f9386463e67cfd85a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c903af9572e0d84dac638d83f79bde19e68906314a0a3c3f9386463e67cfd85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa26ceb3a83343250ea8a40ed653163af9c80a385e5088b173510f851de9fb5f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
