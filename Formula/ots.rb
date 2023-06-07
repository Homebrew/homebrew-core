class Ots < Formula
  desc "🔐 Share end-to-end encrypted secrets with others via a one-time URL"
  homepage "https://ots.sniptt.com"
  url "https://github.com/sniptt-official/ots/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "77101725c2f88a67ec6e4a076c232826c4af265cf0c1348c388ccedcbc4c6492"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f5f84707582f95c31be184797264f4dee0b5dd24ea70425808c99e34ae120d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68af7e8f449b5a6d577c5813b7557878e7f238d5788e1106f6a4e6433f89b31f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3705d1c7a9cbc6df6c147db6d1f4f6b118d35a4284a801cfa6bb86ee4f88e8ac"
    sha256 cellar: :any_skip_relocation, ventura:        "6a2df441f1410725b8ebf4336c54c9394b42c10810b402124ac85fbab65ef49b"
    sha256 cellar: :any_skip_relocation, monterey:       "25b7152c6a0056227e8634bf407c05e1a229a4712660dc870db4f270f95cde67"
    sha256 cellar: :any_skip_relocation, big_sur:        "0500a25106f7d6c5c91592e286ba700fb6855984f8e5f908897329419a569497"
    sha256 cellar: :any_skip_relocation, catalina:       "f497591d14ee77cc308d1c266ca55d0f5c1b6dcaabdfee1116abfedaed448e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3df62978ffc296bd2032e03ec1e2fdb752eae3eb5b25f50e0fcc83c9e33608b1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sniptt-official/ots/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"ots", "completion")
  end

  test do
    output = shell_output("#{bin}/ots --version")
    assert_match "ots version #{version}", output

    error_output = shell_output("#{bin}/ots new -x 900h 2>&1", 1)
    assert_match "Error: expiry must be less than 7 days", error_output
  end
end
