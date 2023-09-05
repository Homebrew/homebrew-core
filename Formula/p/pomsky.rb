class Pomsky < Formula
  desc "Regular expression language"
  homepage "https://pomsky-lang.org/"
  url "https://github.com/rulex-rs/pomsky/archive/refs/tags/v0.10.tar.gz"
  sha256 "a7c02046c8919c16204d66161dfffd4e752ce86657213cb114fe0df9f561a657"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rulex-rs/pomsky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bc84242e960decb30596151d9ffa6f7141bf9952c102a3b68e1e33e8b178b44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79c1fb83c49630eb05d5005a071676c7a82d4a0b3a49db913806ffa043661dd2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27c7b47d0b580a43d932faf0ed064479b71fc2657be5ad250e10681a6c09c028"
    sha256 cellar: :any_skip_relocation, ventura:        "50d1717df00fc80230fa8db2785beb78c3d20e33e55c7b3216e4862a01b930c7"
    sha256 cellar: :any_skip_relocation, monterey:       "9f688b014c303d98a47b92df85c83dab197a96ad40c0e44f1ca227ffcd14c0d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "66debf5cb72985eb6a7933aaacd8070ffdf17f1fd021562e9f417f316c34cdeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bae27e061c5f9cfe506bfbc2513f901fe5bacc5a1a7e4e5602a1de68a61012bb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pomsky-bin")
  end

  test do
    assert_match "Backslash escapes are not supported",
      shell_output("#{bin}/pomsky \"'Hello world'* \\X+\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/pomsky --version")
  end
end
