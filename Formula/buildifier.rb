class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/5.1.0.tar.gz"
  sha256 "e3bb0dc8b0274ea1aca75f1f8c0c835adbe589708ea89bf698069d0790701ea3"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a597d18586fb30489ba3487a6da0297cdbf1690cf44a55fe39686ac7e2ab28ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5067b1bd99a3c972caefb196e7a07204dbd0fb06566554b3056da2b3176eef7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5067b1bd99a3c972caefb196e7a07204dbd0fb06566554b3056da2b3176eef7"
    sha256 cellar: :any_skip_relocation, ventura:        "d1abd4fc1428a62d060627a94f1030e99fcceeca9d2c7ad72f802f63e1588f33"
    sha256 cellar: :any_skip_relocation, monterey:       "b50c4c7e9a0bda54792c4f478417a8678c164aeaf08520d922dd7f8e9ef89bff"
    sha256 cellar: :any_skip_relocation, big_sur:        "b50c4c7e9a0bda54792c4f478417a8678c164aeaf08520d922dd7f8e9ef89bff"
    sha256 cellar: :any_skip_relocation, catalina:       "b50c4c7e9a0bda54792c4f478417a8678c164aeaf08520d922dd7f8e9ef89bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1120f937bbcbbc5d6a37690470e5ec48cc56f1a237683e7bb1e30ebb37a0dab7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
