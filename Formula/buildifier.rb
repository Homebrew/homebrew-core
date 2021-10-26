class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.2.3.tar.gz"
  sha256 "614c84128ddb86aab4e1f25ba2e027d32fd5c6da302ae30685b9d7973b13da1b"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bc3fa86c88b0d80a1539ae4f99f5e77b50fa6b4093dfea55ebdd7c3a5ed5b5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30cc17e7dbbdb450b5b7c914bbe77635c99c6bd0cc106b2796233c085787c525"
    sha256 cellar: :any_skip_relocation, monterey:       "3484eb0afc3b1dfc9cfe44a44c1019c6726198dc822cb9d1b93c73f137b0b734"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f6f2318368bb64129a35dbdb151b215f6e426fedcca5c17d02f633dd147b45a"
    sha256 cellar: :any_skip_relocation, catalina:       "9f6f2318368bb64129a35dbdb151b215f6e426fedcca5c17d02f633dd147b45a"
    sha256 cellar: :any_skip_relocation, mojave:         "9f6f2318368bb64129a35dbdb151b215f6e426fedcca5c17d02f633dd147b45a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "678334bdc3881c60385393786c18f2e7dbe1871f27f1532be9b50bc09ddc2e69"
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
