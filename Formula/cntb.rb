class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54ec070413b9c5bdf3bfed9164a07d0429837e6c5fd5afde34f55acdcdd16f49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdd01eebeea75376c9eb9b6172e498edd2f6b7888798cc998dfe9c7caced9578"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e3b69f24c1877ab7b232021047a5d7353270985624541b6c750b590cb2f6694"
    sha256 cellar: :any_skip_relocation, ventura:        "98ff00e188035b288ba997d47c24acb964a92ad3069336be7fc7fff84bcfd21f"
    sha256 cellar: :any_skip_relocation, monterey:       "93317a2449532e64d492deb9d5a66d4114ae74ab953f18d413a41c51a4f6bfba"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d98f3c1163baf9ef0524ee0c75eaeb0884f76c654f1d451f32646d826fc6cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "089887c966c07d9b2f81f107a7e20c18fe97dfde5e9a67db2c077f5d8cbc9056"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.com/cli/cntb/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"cntb", "completion")
  end

  test do
    # version command should work
    assert_match "cntb #{version}", shell_output("#{bin}/cntb version")
    # authentication shouldn't work with invalid credentials
    out = shell_output("#{bin}/cntb get instances --oauth2-user=invalid \
    --oauth2-password=invalid --oauth2-clientid=invalid \
    --oauth2-client-secret=invalid \
    --oauth2-tokenurl=https://example.com 2>&1", 1)
    assert_match 'level=fatal msg="Could not get access token due to an error', out
  end
end
