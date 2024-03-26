class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/v1.4.10.tar.gz"
  sha256 "f1434b7c7032289c4ea0de0b46f6d26d874f7ce95d6bbb46e1784b019544dc4e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89ff93ce0ca5a1ce403e14b82e4ae6b268474ea5eacf565843387b73b350345c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3f0cbb864af163d8361566b10ef925904680e2a425c4d4cfa00a75e58839a91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6688a97caada9db41d3d479f611fc77ba3f1888fb522a112886ac2d39b05862"
    sha256 cellar: :any_skip_relocation, sonoma:         "c485f069b292523299bc08613e52ff3a5ad221bd6f2f3a978b772a6d7e6fb9e5"
    sha256 cellar: :any_skip_relocation, ventura:        "8297df7d5df41437504b0a271b29fbf8184a01e73c84f50bfbba614022f3041d"
    sha256 cellar: :any_skip_relocation, monterey:       "db02bf9e53b617e0bb337dc6663a1d957c164027ec1e765e9a77b3f49e589109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0652c8855013f7af9d826ee7b539ddb5a629d71bc6747084dbe5f217aae939ff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.com/cli/cntb/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

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
