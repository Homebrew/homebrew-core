class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke.git",
      tag:      "v3.29.1",
      revision: "f8b391177dfed06dc85d16c33c18dbec58838d01"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "515cb56429b035e02ba64c5992a1ff262f7fabe8735285f62c72958512d4def1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "515cb56429b035e02ba64c5992a1ff262f7fabe8735285f62c72958512d4def1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "515cb56429b035e02ba64c5992a1ff262f7fabe8735285f62c72958512d4def1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e17345becde19b1104f788a347549af7664b27925d0eee810707121e3fa34c2"
    sha256 cellar: :any_skip_relocation, ventura:       "4e17345becde19b1104f788a347549af7664b27925d0eee810707121e3fa34c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "396b53826e103434ae86b9be5e03a115fe34ef712cf4ac7cef8fac98e271d97f"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.com/ekristen/aws-nuke/v#{version.major}/pkg/common"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.SUMMARY=#{version}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags:)
    end

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
