class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      tag:      "3.5.0",
      revision: "10384511ce98d864faf064a8ed54cdf31b98ac04"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "21da6d6c0020f91ea197b48dbc5a108527d9aa2e41b47406d79403d49fda164e" => :big_sur
    sha256 "154877a4bfb01a9fd0498a42015e75ca3df72d7c2b92c47254866c8b9832ceb4" => :catalina
    sha256 "36f2f0c2946d5e3a79f9287285cf335f14b1f181190907dfc29b12231764bc49" => :mojave
    sha256 "5b54427b4bd78b0b3dccfd66b8003a52aab3b4d1a7683586b66d6a6c835c0b4b" => :high_sierra
  end

  depends_on "bazelisk" => :build

  def install
    system "bazelisk", "build", "--config=release", "buildifier:buildifier"
    bin.install "bazel-bin/buildifier/darwin_amd64_stripped/buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
