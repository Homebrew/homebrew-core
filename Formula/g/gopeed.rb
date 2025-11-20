class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https://gopeed.com"
  url "https://github.com/GopeedLab/gopeed/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "61750c024e9a1e476ced472427ab77158deccdc756b5478b3ca72a3705a23fe8"
  license "GPL-3.0-or-later"
  head "https://github.com/GopeedLab/gopeed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4263f1306432705a2232f7f003d07a488a6ec1c50d9ec35565efb1670b0ab6af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ef56d43cdff387f1dcfe3fdfd0e1e915d49fed672ab6d337de1ba2734339ff9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f1564b4927ed521c86ea03599e582e7a3f044b41f3446183da783646bef39c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8a3659d5ea9898093e63aa4a930f2a0e7cc79455be2f1bbaea7c459c4197c06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcc65dcac5e8275adba4afb4888c3391f65135ad2b76dd3ff357b806e64585fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9be77a411f0552690092868dc04ee84e1ee991c5ddee39f6593626ff3d41bae5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gopeed"
  end

  test do
    output = shell_output("#{bin}/gopeed https://example.com/")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath/"example.com").read
  end
end
