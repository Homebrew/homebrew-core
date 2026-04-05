class Qi < Formula
  desc "Local-first knowledge search CLI"
  homepage "https://github.com/itsmostafa/qi"
  url "https://github.com/itsmostafa/qi/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "a682c42265cfcdcb9f89bb136f913f2a26112970913e28816d4fd8db4b0fb4ad"
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
