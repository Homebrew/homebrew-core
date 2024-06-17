class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://github.com/synfinatic/aws-sso-cli"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "276d3f257ad8299d43c60ed4c87ddc72c9c14d29efa91fa8b27b3fb49f2acbd0"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2180f62bdc51f75152a059e63202f66f1d8c5dcff5d058262c3219529a1055ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9603b79d6aed4ac82e4f73a74f5e7c7c6ea73596562a557f0789c6c38bab343"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3183cec9199136bd68a2eca7adeb0a45a7f5e276a995ea403e5d0b8ba52afb1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "34d357e055f45f1459765d091235929d496c4dcd826575f4c656917c60cb06eb"
    sha256 cellar: :any_skip_relocation, ventura:        "4eb2aae5b89c8679a6fe2f7ba525f770958048f8b504ebcfb263e79935790e50"
    sha256 cellar: :any_skip_relocation, monterey:       "55a43f9042182176317a158d3cf8a5168970cb73b6a521398dbe97541ef0d78a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51377617b355fe27abc09f8a397e63519c13509cfca9b9178bdcbb9f21d78f9d"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Buildinfos=#{time.iso8601}
      -X main.Tag=#{version}
      -X main.CommitID=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"aws-sso"), "./cmd/aws-sso"
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}/aws-sso version")
    assert_match "No AWS SSO providers have been configured.",
        shell_output("#{bin}/aws-sso --config /dev/null 2>&1", 1)
  end
end
