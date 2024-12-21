class Neverest < Formula
  desc "Synchronize, backup, and restore emails"
  homepage "https://pimalaya.org"
  url "https://github.com/pimalaya/neverest/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "7fc3cdfb797026c68a4e1aebd65ad69b604900e9c51970403633d82f54e6a4ce"
  license "MIT"
  head "https://github.com/pimalaya/neverest.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"neverest", "completion")
    system bin/"neverest", "manual", buildpath
    man1.install "neverest.1"
  end

  test do
    assert_match "neverest", shell_output("#{bin}/neverest --help")

    output = shell_output("#{bin}/neverest check 2>&1", 1)
    assert_match "Cannot find existing configuration", output
  end
end
