class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/3.8.tar.gz"
  sha256 "1041d27ef87a6fb123740d6423cd3fd66ced0ccf43d834c8d421aad3c8e8c96b"
  license "AGPL-3.0-only"
  head "https://github.com/bensadeh/circumflex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "452a6764489fafe9f61ed53a7e83a578ae1ab2ccc4c307a22e3a3f25157f5483"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7703a8fe49c3a13299c37b9bd75f42674a245a866148a0d71d0b050be0e5b441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7703a8fe49c3a13299c37b9bd75f42674a245a866148a0d71d0b050be0e5b441"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7703a8fe49c3a13299c37b9bd75f42674a245a866148a0d71d0b050be0e5b441"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b50ad11b46f45cde111438cb6f63bf91c204d55dc054175b74da06cea8b68da"
    sha256 cellar: :any_skip_relocation, ventura:       "9b50ad11b46f45cde111438cb6f63bf91c204d55dc054175b74da06cea8b68da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53c94f24dca42570b50974959436b94e090dc99d380e9226b29b72f9f1c43630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186c35290bbefbbf90f8e42467aebf479c405be7d4803a66dee198b6dbbcf879"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx article 1")
  end
end
