class Cig < Formula
  desc "CLI app for checking the state of your git repositories"
  homepage "https://github.com/stevenjack/cig"
  url "https://github.com/stevenjack/cig/archive/v0.1.5.tar.gz"
  sha256 "545a4a8894e73c4152e0dcf5515239709537e0192629dc56257fe7cfc995da24"
  license "MIT"
  head "https://github.com/stevenjack/cig.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3b74f7b2d3b2d121ccb6946718893b4f0c09d6bae5e5a6a7d48b8144da9b452"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48e80e3f418f825caceccd69e9ec911f5c03b8fa7f38883edfd66d353f70a481"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d4f345393a0553e40003b46523a07e2bb0162bba0309ca9c0d322f606e73b76"
    sha256 cellar: :any_skip_relocation, ventura:        "340790bf6ab897640e1a1f350d8c106d3bc2835ad71cec69b7a717894749cc35"
    sha256 cellar: :any_skip_relocation, monterey:       "fbca3e3336ec9a9848091d2b1845a48dc915ae798da5e1d54fe6aa4ee2261da6"
    sha256 cellar: :any_skip_relocation, big_sur:        "c41c70e517158f1a31bb4b29a6fa01b12570001353b8800d55aadd4ddc99080e"
    sha256 cellar: :any_skip_relocation, catalina:       "3ccce3238efd259041dbb0f0427d5ac06cc4dfafdfbfd336ddd0023e02e9dd7d"
    sha256 cellar: :any_skip_relocation, mojave:         "9cf50d9418885990bed7e23b0c2987918d63bef3e7f3e27589c521b6b73160bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cda091fe20f715097967b89ee16f611d3f26faac9eb4d3f7861ec5d9cb91201"
  end

  depends_on "go" => :build

  # Patch to remove godep dependency.
  # Remove when the following PR is merged into release:
  # https://github.com/stevenjack/cig/pull/44
  patch do
    url "https://github.com/stevenjack/cig/compare/2d834ee..f0e78f0.patch?full_index"
    sha256 "3aa14ecfa057ec6aba08d6be3ea0015d9df550b4ede1c3d4eb76bdc441a59a47"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    repo_path = "#{testpath}/test"
    system "git", "init", "--bare", repo_path
    (testpath/".cig.yaml").write <<~EOS
      test_project: #{repo_path}
    EOS
    system "#{bin}/cig", "--cp=#{testpath}"
  end
end
