class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://github.com/kovetskiy/mark"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v16.4.0.tar.gz"
  sha256 "86c0314ebbd18512120c06950d80ec3126bbcc4b62f4f561c7ad4523ffd78b0a"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79d3ad843e52bcc2eb6585d7edac0296655553ef1ab835f4b1f83e0df907b7c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79d3ad843e52bcc2eb6585d7edac0296655553ef1ab835f4b1f83e0df907b7c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79d3ad843e52bcc2eb6585d7edac0296655553ef1ab835f4b1f83e0df907b7c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5bc862ef72259beb035fa7a1b0f98cadf16ca7f2da9b17260a601a7e1c27292"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e96c80870e02d8f4f925f2e84962149cc3b13047a1566d4e4f8fd9b42b58272b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5d4bbb66c5885b2e0dc326e1a752136d622e7b5d54ec11e3061ec64e69a9c4c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end
