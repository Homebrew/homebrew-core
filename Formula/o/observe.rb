class Observe < Formula
  desc "Command-line access to the Observe API"
  homepage "https://developer.observeinc.com/"
  url "https://github.com/observeinc/observe/archive/refs/tags/v0.3.0-rc2.tar.gz"
  sha256 "3c326e456fa6497cfc8e1b3c903b590a7293a0b7d1616359b93fde22b64aff0b"
  license "Apache-2.0"
  head "https://github.com/observeinc/observe.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %w[
      -s -w
    ]

    system "go", "build", *std_go_args(ldflags:), "./"
  end

  test do
    output = shell_output(
      "#{bin}/observe --customerid 0 --site observeinc.com login --sso not-a-real-email@example.com 2>&1",
      1,
    )
    assert_match "authorization failed", output
  end
end
