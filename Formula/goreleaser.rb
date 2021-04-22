class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.164.0",
      revision: "d822baf11f7773f6c02eeaf7e187157b335935b3"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea170633f318942da38b7e457d95e0a09e69b0eb2d4ae4efab103f305ad9281a"
    sha256 cellar: :any_skip_relocation, big_sur:       "95ba6ff13205c7a5b154ce733e79fa379e571c4105f4e4cb81002cd0908b007b"
    sha256 cellar: :any_skip_relocation, catalina:      "0fe5221a6c8b1df1c7fb6acada38025cb6b84cfda3640e01b4d625ef54ae94d0"
    sha256 cellar: :any_skip_relocation, mojave:        "1ce637c2d502f82c6573551318bd8bc8dabfea82789926fe71c9ba906257e213"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=homebrew",
             *std_go_args

    # Install shell completions
    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "bash")
    (bash_completion/"goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "zsh")
    (zsh_completion/"_goreleaser").write output

    output = Utils.safe_popen_read("#{bin}/goreleaser", "completion", "fish")
    (fish_completion/"goreleaser.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
