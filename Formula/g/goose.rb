class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.27.0.tar.gz"
  sha256 "4bc91796341475bed5686a59ee84ebd695e6738a9cdbf805f8efeebbe73716ee"
  license "MIT"
  head "https://github.com/pressly/goose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09e1efb554269c8265ffbbad3437720de3db171504362ae3336ab22ef2336e2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fce429cdb7e1d4b4bba0ac2d4c6b515b57dd75847be3a2103419e70f9c83d504"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86a3f4e3d54e726793f2a6e20aa0e56305f403e4174725bfc6032ccd0adf5632"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae635028df61e39a05e73d56e069bce779b43e9ff0d155100025c452c7bbe109"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5889c91f2942f52db67e8959a146100a90b2fb95be2f466001589783bf5892b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3ff9f656a18cd24255a8a13be71670da8ac78c71ca174c228dc432cac271574"
  end

  depends_on "go" => :build

  conflicts_with "block-goose-cli", because: "both install `goose` binaries"

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
