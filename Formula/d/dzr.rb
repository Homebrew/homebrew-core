class Dzr < Formula
  desc "Command-line Deezer.com player"
  homepage "https://github.com/yne/dzr"
  url "https://github.com/yne/dzr/archive/refs/tags/240609.tar.gz"
  sha256 "73e633aae231a312ac344ffb847884a70e6f0a3195e1246c00e9eda1e9df7b21"
  license "Unlicense"
  head "https://github.com/yne/dzr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cc2a38c370cd729ef941b45cee61ae8a4f11b3fd256c9e8672217d683655d30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cc2a38c370cd729ef941b45cee61ae8a4f11b3fd256c9e8672217d683655d30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cc2a38c370cd729ef941b45cee61ae8a4f11b3fd256c9e8672217d683655d30"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cc2a38c370cd729ef941b45cee61ae8a4f11b3fd256c9e8672217d683655d30"
    sha256 cellar: :any_skip_relocation, ventura:        "4cc2a38c370cd729ef941b45cee61ae8a4f11b3fd256c9e8672217d683655d30"
    sha256 cellar: :any_skip_relocation, monterey:       "4cc2a38c370cd729ef941b45cee61ae8a4f11b3fd256c9e8672217d683655d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3634f1f247ca10ff9b0e86d94dcca5d3bd995400eaa6800f672f5579780a7773"
  end

  depends_on "dialog"
  depends_on "jq"
  depends_on "mpv"
  uses_from_macos "curl"

  def install
    bin.install "dzr", "dzr-url", "dzr-dec", "dzr-srt", "dzr-id3"
  end

  test do
    ENV.delete "DZR_CBC"
    assert_equal "3ad58d9232a3745ad9308b0669c83b6f7e8dba4d",
                 Digest::SHA1.hexdigest(shell_output("#{bin}/dzr !").chomp)
  end
end
