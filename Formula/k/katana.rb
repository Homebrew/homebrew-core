class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://github.com/projectdiscovery/katana/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "81ce8b6047e9463c37e9cf7dd3bdcd30d8a61e2da9cf6c960ccd409b99c896ee"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bfc078d79780ccac057959f0558f5ddeb24c8a17a86872a2ff9ec581391175c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bfc078d79780ccac057959f0558f5ddeb24c8a17a86872a2ff9ec581391175c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bfc078d79780ccac057959f0558f5ddeb24c8a17a86872a2ff9ec581391175c"
    sha256 cellar: :any_skip_relocation, sonoma:        "09717b46491071ddc0cccc5181c497df3af7819003490fdc66dacaa9332d137c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bacfb589d573b6287c94dac6bd10e9b76916ea2fbdba38f75e2327ece83b0f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db408c751c35b942a42d54203495eb1cd348e53a0618e181a248afea1add8660"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    # Replace self-update with a notice; brew manages updates.
    inreplace "internal/runner/banner.go" do |s|
      s.gsub! 'updateutils "github.com/projectdiscovery/utils/update"',
              '_ "github.com/projectdiscovery/utils/update"'
      s.gsub! 'updateutils.GetUpdateToolCallback("katana", version)()',
              'gologger.Info().Msgf("Run `brew upgrade katana` to update.")'
    end

    ldflags = %W[
      -s -w
      -X github.com/projectdiscovery/katana/internal/runner.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end
