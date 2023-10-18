class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v6.3.3.tar.gz"
  sha256 "42968f9134ba2c75c03bb271bd7bb062afb7da449f9b913c96e5be4ce890030a"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b42897cbf09c84898ffe1904ad0b6b3b79bcb52e7c9c6ca32c9bcdc12ae3ba0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "589335bc64b8abb27ddc067d45997690d127e4d68ce65f6b9779aadec86b4740"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "589335bc64b8abb27ddc067d45997690d127e4d68ce65f6b9779aadec86b4740"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "589335bc64b8abb27ddc067d45997690d127e4d68ce65f6b9779aadec86b4740"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ab0626f6f0de00aad10aa8dd3ecbfdeab1e7b953fc3e835c91dddd1ecd6fc8a"
    sha256 cellar: :any_skip_relocation, ventura:        "bb31887f6435b72704f5796c18b37e2bca69d27421b1950b4e961401ec0f1760"
    sha256 cellar: :any_skip_relocation, monterey:       "bb31887f6435b72704f5796c18b37e2bca69d27421b1950b4e961401ec0f1760"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb31887f6435b72704f5796c18b37e2bca69d27421b1950b4e961401ec0f1760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8037b227982aa454aaa4c574e76818a1ed4b702c82f0d363ee243db75482e1fb"
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
