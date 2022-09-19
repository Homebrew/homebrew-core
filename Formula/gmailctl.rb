class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.10.5.tar.gz"
  sha256 "53410051ad246e452878d7b9de241a7173f588ec2b68f02adb40e7ec01b16912"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6291b1c2d62390a30f81996f167b51e682a8698aae64ec263966036fba2472f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cccccada372c4751529dfb69b13e57fd447b62c1a9f37ace4c02ca6679d10f2"
    sha256 cellar: :any_skip_relocation, monterey:       "8b87f1acbd6ae331dc54d61f4cc8b31f69d6660434a70228c01ab13fca0d9190"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c0e96ba1ce38941c3946465299ad2907e553c19492e1489110924122ba10221"
    sha256 cellar: :any_skip_relocation, catalina:       "6630a2bce7ad07d1bb3bb2414faa4c1c7962bf9f686a5604f8094e3eae81ac85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f9a98d152671158da7c1e1a3ab2c2562e59e32ae73c0f0a61b8bc8f47a4e72e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/gmailctl/main.go"

    generate_completions_from_executable(bin/"gmailctl", "completion")
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1", 1),
      "The credentials are not initialized"

    assert_match version.to_s, shell_output("#{bin}/gmailctl version")
  end
end
