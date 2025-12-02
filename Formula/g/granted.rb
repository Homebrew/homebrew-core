class Granted < Formula
  desc "Easiest way to access your cloud"
  homepage "https://granted.dev/"
  url "https://github.com/fwdcloudsec/granted/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "b6e2bc8fda38f55ee4673cc0f3f762e076d2029df1d9a8552681a2aacce88721"
  license "MIT"
  head "https://github.com/fwdcloudsec/granted.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2ae7e586190f7c5092da72f5e510a4c280b55c114975e39a9b5ca500ef5f601"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc90ac61d24f078333207f04e4750cbb0be674734ad42ee2f1c3d449069f7d95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f72bc786bb6f5e3bd0d23150d07c1f9a889d06b42a728589114ebb418b3bd505"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad6688f253dd0a2440dd3e3a4201bdfd729e77ef33b62e33668961c63bbe7386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaf45439a1a8f236a254b8db441fada6c8813b314ed479aa65f201be47b031dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "534d96a5ee4e3075598d6be97a10c2df041a4fcf6f95f3498299fd9a777a0130"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/common-fate/granted/internal/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/granted"
    bin.install_symlink "granted" => "assumego"
    # these must be in bin, and not sourced automatically
    bin.install "scripts/assume"
    bin.install "scripts/assume.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/granted --version")

    output = shell_output("#{bin}/granted auth configure 2>&1", 1)
    assert_match "[✘] please provide a url argument", output

    ENV["GRANTED_ALIAS_CONFIGURED"] = "true"
    assert_match version.to_s, shell_output("#{bin}/assume --version")
    assert_match version.to_s, shell_output("#{bin}/assumego --version")

    # assume is interactive; pipe_output provides empty stdin causing prompts to fail.
    # Match varies by environment: "does not match" (with browser), "Could not find
    # default browser" (no browser configured), or "EOF" (when stdin closes).
    output = pipe_output("#{bin}/assume non-existing-role 2>&1", "")
    assert_match(/does not match any profiles|Could not find default browser|EOF/, output)
  end
end
