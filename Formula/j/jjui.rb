class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.8.12.tar.gz"
  sha256 "355f3e3c5136ced3526127c119c1402b2e31a396535ec7425a18b80566f12140"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8ec79321aff1316dd3cb36dba93e3bf999ad4634f9477fd76ef981d40296164"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8ec79321aff1316dd3cb36dba93e3bf999ad4634f9477fd76ef981d40296164"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8ec79321aff1316dd3cb36dba93e3bf999ad4634f9477fd76ef981d40296164"
    sha256 cellar: :any_skip_relocation, sonoma:        "21f17e7939c0c8664fef77fa1d7c3cd72192a36e870d43a19e61515723522451"
    sha256 cellar: :any_skip_relocation, ventura:       "21f17e7939c0c8664fef77fa1d7c3cd72192a36e870d43a19e61515723522451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbcc9b1b2acd60a7c31595281c94b84fdcf6b213381abc190f0b93c7c6a19313"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "Error: There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
