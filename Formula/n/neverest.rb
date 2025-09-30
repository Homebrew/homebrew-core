class Neverest < Formula
  desc "Synchronize, backup, and restore emails"
  homepage "https://pimalaya.org"
  url "https://github.com/pimalaya/neverest/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "7fc3cdfb797026c68a4e1aebd65ad69b604900e9c51970403633d82f54e6a4ce"
  license "MIT"
  head "https://github.com/pimalaya/neverest.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8724834d76f0b3ae85de2cd78efd915e013ea6e73e6fcc4aace2fe2bca4ee2ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ea446d70657b4a63b0cea2a1f008409435072a5e99610924f6b5b1dc0efff1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c4727f47e9b3c380fb966ac11ef3196bd253849273c5a129e1cfe2daec11d81"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0bfb4590e4ed67783d07008166e55a110f77f466ca4bc213e46d6da64d7f84b"
    sha256 cellar: :any_skip_relocation, ventura:       "3b7f30508d20583c20c986afaece33d669f9380e79cdde2793c41a9b3fde0e9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "475ccca123e3cd0593237f8e7ad0bff2b6b0e1cfb29b3d40950ff279790280cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42967910c00046d764d281458105af646720163beb854aa14aa8740fbd54ee8f"
  end

  deprecate! date: "2025-09-20", because: :does_not_build

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"neverest", "completion")
    system bin/"neverest", "manual", man1
  end

  test do
    assert_match "neverest", shell_output("#{bin}/neverest --help")

    output = shell_output("#{bin}/neverest check 2>&1", 1)
    assert_match "Cannot find existing configuration", output
  end
end
