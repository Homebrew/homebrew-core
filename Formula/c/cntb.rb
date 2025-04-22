class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https://github.com/contabo/cntb"
  url "https://github.com/contabo/cntb/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "d5648e7c842b46414466f62fb412cceebe284afbecfddf7ba92822510831c235"
  license "GPL-3.0-only"
  head "https://github.com/contabo/cntb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "830067d19a3686b22c00ebca17b5a0d7eb0b5ab4adb176a4efd2aac726bd8a32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "830067d19a3686b22c00ebca17b5a0d7eb0b5ab4adb176a4efd2aac726bd8a32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "830067d19a3686b22c00ebca17b5a0d7eb0b5ab4adb176a4efd2aac726bd8a32"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4d8804494b48a319a47798806c89b91e706aee64f1fa3012204c6c715a389ba"
    sha256 cellar: :any_skip_relocation, ventura:       "b4d8804494b48a319a47798806c89b91e706aee64f1fa3012204c6c715a389ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3726f458d23d4ad503188858741bffbb3a7a5af4acc77435c579fc4c8a56095c"
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
