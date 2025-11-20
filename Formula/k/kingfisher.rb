class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.65.0.tar.gz"
  sha256 "d47341b1125efe3f0c10c481cb422d73513dd5101a966e461b4e8c77fbebcb96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8809416bcbd2c681fa62648ad00ffd289eb5427e8d17c989d290634327f07eb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "362fcca4f0dc6c456c29ca27c82a0f7699c808601111f4c5a2504f02533f0c33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f811d6aa411526d55512436d0ecf95f919bb6cca6110f892cb38877e3a4a714"
    sha256 cellar: :any_skip_relocation, sonoma:        "8db38c024c48977ee34abd55702d0cbcd1a2fb4b592e995c2ac0ef263eda6f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afff60331ed2e9cb6515d781f99ba67ffdeb91f5d63c8cd90988b3a9654bef15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "747f93d0ed515dca677fafb9da5719f37687c306730db61bf624a726409a9290"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
