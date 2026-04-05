class Qi < Formula
  desc "Local-first knowledge search CLI"
  homepage "https://github.com/itsmostafa/qi"
  url "https://github.com/itsmostafa/qi/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "faacbdbfbca7683363bda0d390b6408fcb46b40e70b0613a7b7be942a44873e3"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/itsmostafa/qi/internal/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/qi version")
  end
end
