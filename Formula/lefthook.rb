class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.8.tar.gz"
  sha256 "b9c46cd9e209d15bcb7ff0570a2d65f4d3c2d40345883bd724ecf7f4927be969"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f0a5873480992a164509d73e943265e440932de1a3197caf41dca9a5f1fbe6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f0a5873480992a164509d73e943265e440932de1a3197caf41dca9a5f1fbe6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f0a5873480992a164509d73e943265e440932de1a3197caf41dca9a5f1fbe6e"
    sha256 cellar: :any_skip_relocation, ventura:        "e74bce37f94a29593416896dd74412753f2ee703142e1eac9cf8f5b1e1de8e63"
    sha256 cellar: :any_skip_relocation, monterey:       "e74bce37f94a29593416896dd74412753f2ee703142e1eac9cf8f5b1e1de8e63"
    sha256 cellar: :any_skip_relocation, big_sur:        "e74bce37f94a29593416896dd74412753f2ee703142e1eac9cf8f5b1e1de8e63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a2cf052763d03cd29bf0509a790bb77efb9eb7b61392dda6fffe7fd704bd969"
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
