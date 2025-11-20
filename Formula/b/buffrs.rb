class Buffrs < Formula
  desc "Modern protobuf package management"
  homepage "https://github.com/helsing-ai/buffrs"
  url "https://github.com/helsing-ai/buffrs/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "e4e3cb4536d1fd879ab1590cf319cae04884689ac491e1e5f88920317ca836a4"
  license "Apache-2.0"
  head "https://github.com/helsing-ai/buffrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f93f45e43b9e6c24abfb95eacd98a0d8c426f8bd9b490d2de953d1432bba6387"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64df0773c69496f6087d400abace040093e6491d3aa13d56f5be305087703f86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ab0f49ceae5b280e7966a057b3c7bd06999d506f71c485cee3d9ad57720969e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb45d7e086b12deb3af6abf3bbfb872fd275d47352703b74fd03c303cedd1437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11302ac8316035004f2a47b6908460de8193d47cf04c3baa5d7c73dd04c8affd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "352b9c193601d6e97253bf6cf64dae6b9bbc772ded8ef13e35f655c2432504d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buffrs --version")

    system bin/"buffrs", "init"
    assert_match "edition = \"#{version.major_minor}\"", (testpath/"Proto.toml").read

    assert_empty shell_output("#{bin}/buffrs list")
  end
end
