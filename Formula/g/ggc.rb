class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.7.2.tar.gz"
  sha256 "baeff020de9cb5ced3da94d50805727071c9faa5bc06089b14404430f95b9334"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48fbdf2b18a27508a28e9783367a03c43ea004e8f2c9eb864b61552ea38dd05a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48fbdf2b18a27508a28e9783367a03c43ea004e8f2c9eb864b61552ea38dd05a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48fbdf2b18a27508a28e9783367a03c43ea004e8f2c9eb864b61552ea38dd05a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fe22060cdcb204b5f8aaf6c4c9449678eabedf7dec6a87753908abc9a121152"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2304fdc7307573224286c4368f76e5e6aa261bfecd8d430ac196a650a55c926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4685464a867f75ff7ea66e379bd783a3f93031211fc3aa376542af9d50b883f"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
