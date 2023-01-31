class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.20.3.tar.gz"
  sha256 "bf35aac0139472ad41b2cd9814440e09ea0905e2140db4bb28918204c825ae76"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dddca139acdb1e23e592d65b0721e8310cb470c2022c0c3019722b16806b8df0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c25c9e977f9b21a143121859862339077b5dc246c21ed4becf6ec10be58719c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc40f6fdb1cb8f84b30f475b1a5b2ee924df4674208f2ce3cedb64e2f4ff00c5"
    sha256 cellar: :any_skip_relocation, ventura:        "86a6c17b8bfd3cef4909c2273ac5dbbb5ac306c53244bf1b4664b6b7378246ed"
    sha256 cellar: :any_skip_relocation, monterey:       "497f25580b999d3e7a8e7081831469f3b17e211834b54963d0b917ba62e3d7d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "50eca8c2da80e295dac21c0426c26e2b738b0da5fa08529410c3e5cdca718d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc74ae4794ffe3d3b46c94d84568629408fc54a6ec8db94a6e26c8a733a50ce9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
