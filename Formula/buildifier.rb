class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.0.1.tar.gz"
  sha256 "c28eef4d30ba1a195c6837acf6c75a4034981f5b4002dda3c5aa6e48ce023cf1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "21da6d6c0020f91ea197b48dbc5a108527d9aa2e41b47406d79403d49fda164e"
    sha256 cellar: :any_skip_relocation, catalina:    "154877a4bfb01a9fd0498a42015e75ca3df72d7c2b92c47254866c8b9832ceb4"
    sha256 cellar: :any_skip_relocation, mojave:      "36f2f0c2946d5e3a79f9287285cf335f14b1f181190907dfc29b12231764bc49"
    sha256 cellar: :any_skip_relocation, high_sierra: "5b54427b4bd78b0b3dccfd66b8003a52aab3b4d1a7683586b66d6a6c835c0b4b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
