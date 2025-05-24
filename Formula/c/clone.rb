class Clone < Formula
  desc "Download repository only a specific branch or tag without the entire history"
  homepage "https://github.com/lizongying/clone"
  url "https://github.com/lizongying/clone/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "0595397d0ec16e958ce132cde4c7652f276a75fc2e846a7e697cbc9f14389feb"
  license "MIT"
  head "https://github.com/lizongying/clone.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "ab027f92294742df796186586b7395cd06064c01b177fa5ffb9f6d5fa4f4c456"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"clone", "--version"
  end
end
