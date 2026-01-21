class Gitu < Formula
  desc "TUI Git client inspired by Magit"
  homepage "https://github.com/altsem/gitu"
  url "https://github.com/altsem/gitu/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "68a014a5b6b920ae1f82b473e7dddf9251755ada57df126c9a0a98725d1552bb"
  license "MIT"
  head "https://github.com/altsem/gitu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05ca82c535aa71bb8ff69629c273c289f9fcfc1d96ae0dd9cc4950d75f88221f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "491753a806e403005635f8930a0b08ec9349e0b506ac5782df94083b8a266ca5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "917180e227c107ac20ab1ba17e4f5f29c43ac80a17b0390e5a685fad7a68ff65"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbc9a5bb0e1eddafcdf434b0a62f27782ba378b5a489e519a4fa3b7bae4ac0fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99440f8c83744f5533fdd89c57463c758117d57ce3ed8d142fb641534818193d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e2209e3932918766807d7e419b8ffe86138320c550531cae6f744e86c8ecab"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitu --version")

    output = shell_output("#{bin}/gitu 2>&1", 1)
    if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      assert_match "No such device or address", output
    else
      assert_match "could not find repository at '.'", output
    end
  end
end
