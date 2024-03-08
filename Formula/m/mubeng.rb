class Mubeng < Formula
  desc "Incredibly fast proxy checker & IP rotator with ease"
  homepage "https://github.com/kitabisa/mubeng"
  url "https://github.com/kitabisa/mubeng/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "27842f0d587ced3b79b3c5e68be7e59272b0f2e89f754e3322d17bf7eda6802c"
  license "Apache-2.0"
  head "https://github.com/kitabisa/mubeng.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X ktbs.dev/mubeng/common.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mubeng"
  end

  test do
    output = shell_output("#{bin}/mubeng 2>&1", 1)
    assert_match "no proxy file provided", output

    assert_match version.to_s, shell_output("#{bin}/mubeng --version", 1)
  end
end
