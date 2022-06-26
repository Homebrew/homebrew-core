class Aurora < Formula
  desc "Beanstalkd queue server console"
  homepage "https://xuri.me/aurora"
  url "https://github.com/xuri/aurora/archive/2.2.tar.gz"
  sha256 "90ac08b7c960aa24ee0c8e60759e398ef205f5b48c2293dd81d9c2f17b24ca42"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5187558579ceb4884f08f91855d393bb0f0b79b7ac5a4ff1abc1cdc43a780006"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "798b63da7188da92582ffde96fed8f3407add006f2db88a610cb4aacda1c5b89"
    sha256 cellar: :any_skip_relocation, monterey:       "fc1e371ec7afa848b85dd45424209ed1d9da85985e9cf5cc21a6ae46071847bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "714b7116c80107b6ffb0f5b8abba41ae5aa88708fe688e61144ca3a636b7fc4f"
    sha256 cellar: :any_skip_relocation, catalina:       "f3b45006b5b5c6f15166d11d1a740fb14f3b22c1d64b3b64397ed2958e9c882d"
    sha256 cellar: :any_skip_relocation, mojave:         "21abebb582fbac2ebb400328b455c890206f78ae0910f75ded8019bfc6a40c1f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e3e9b06b4b9053afb4b75b48d90555d00fcc8404309d8b2b2b336538810746cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c045ae045444b0e5f6ad993b2d30697908b1925132ea47fe2d25b46e729a760c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"aurora"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aurora -v")
  end
end
