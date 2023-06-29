class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "870dc85504d677c10d514f5a8f4bfaf328e6990892a1bc169a2f44616203b56f"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aac569cd7337c32d4cade2bef4e20c8cd52c133f422d3e40a7e3b35c85a6dfaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aac569cd7337c32d4cade2bef4e20c8cd52c133f422d3e40a7e3b35c85a6dfaf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aac569cd7337c32d4cade2bef4e20c8cd52c133f422d3e40a7e3b35c85a6dfaf"
    sha256 cellar: :any_skip_relocation, ventura:        "d46779ecc34994d5cc61fd99fcb7fee29eabc40dbadae25e1ca3521ac08ada4f"
    sha256 cellar: :any_skip_relocation, monterey:       "d46779ecc34994d5cc61fd99fcb7fee29eabc40dbadae25e1ca3521ac08ada4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d46779ecc34994d5cc61fd99fcb7fee29eabc40dbadae25e1ca3521ac08ada4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae5c75b91bffbfc0694a2548e710f2f4dd65cf3ed1597b32ddc67ac1f13edf5"
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
