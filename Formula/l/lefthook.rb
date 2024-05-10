class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.6.10.tar.gz"
  sha256 "c789b9a4433c9db064c47469adaa45940b522924ed31be3c0ae38e559e38ef07"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a3c29c2919c9c722dae5fbcae5cb2e0c16e5c0d1de32777ef18810cd1e9092d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fbd24805b19798fb94c6d75abed54804d9885c7647271296d1bf343c087f450"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cf7f2088b1265df906998a8a7d37edec8a35cd310554cdf592439bb253f2c79"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd18a5e87100c33abe01fa42c1a701f4e784a0f471294da427490af8923c7126"
    sha256 cellar: :any_skip_relocation, ventura:        "d971baa72739d7748ce9f147c07ef2e7cb67913b3fdbc0890d6b3c689e5f9d9a"
    sha256 cellar: :any_skip_relocation, monterey:       "aed14ace3c2142b07780cb337db688ef4c5fcea62a77dff46628d312cc305b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bee3dad29966b338b346d3757b94c3c042d1e1c828e45dc3216b1b3533b4dec5"
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
