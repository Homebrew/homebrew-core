class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "c02856a2e360d2ccb05137352a2aad3805a35d32571839d4fb232a2d40c630f8"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e14a5092fdceabb74a714bfcb0223f7ebd42f37b95bc65349615e7d5d3dfd78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6086c67490c4964a9267c8191e8ab28762125d3fd5a6fe0709097865ffb0d0fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e048d290caf5132e20ca7253e945746d654de3d0d0ccb3032618bc3a25666e01"
    sha256 cellar: :any_skip_relocation, sonoma:        "1070248f63a403ae88598e48ec1b59ce4edb141d7f4897cf4f7b95be7a0feaf0"
    sha256 cellar: :any_skip_relocation, ventura:       "2ceea9b8ed585f9b9882bc7055d99159858330e355672bd44dab9eeba0cadd5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6031b8eec92db02de33a30836410ce1c5410e8494503a8604c7fe26154e9b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d91a19af6f0a0dd542b34b660d795b18bf7b8ed830fc963afd08793202a1afd6"
  end

  depends_on "rust" => :build
  depends_on "libusb"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/cyme.1"
    bash_completion.install "doc/cyme.bash" => "cyme"
    zsh_completion.install "doc/_cyme"
    fish_completion.install "doc/cyme.fish"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = JSON.parse(shell_output("#{bin}/cyme --tree --json"))
    assert_predicate output["buses"], :present?
  end
end
