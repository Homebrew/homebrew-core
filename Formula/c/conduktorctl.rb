class Conduktorctl < Formula
  desc "Conduktor CLI performs operations from your terminal or a CI/CD pipeline"
  homepage "https://www.conduktor.io/"
  url "https://github.com/conduktor/ctl/archive/refs/tags/0.1.0.tar.gz"
  sha256 "d76471829c0c6493faf0a1f4d7baac85d8da61fc0254cdaf80c76b8bfa76d8f0"
  license "Apache-2.0"
  head "https://github.com/conduktor/ctl.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"conduktor")
  end

  test do
    output = shell_output("#{bin}/conduktor 2>&1", 1)
    assert_match "Please set CDK_TOKEN", output
  end
end
