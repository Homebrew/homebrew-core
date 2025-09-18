class Ddh < Formula
  desc "Fast duplicate file finder"
  homepage "https://github.com/darakian/ddh"
  url "https://github.com/darakian/ddh/archive/refs/tags/0.13.0.tar.gz"
  sha256 "87010f845fa68945d2def4a05a3eb796222b67c5d3cea41e576cfaf2ab078ef8"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2b2788b0596f11e1662e743517535b5b5d61a034fa8b6ad5d4df84853905e58e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c38c189b4375eb8031c68bcd0c6f070ec7ce5c851306322d0b15d5c0a797f242"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bea4c9d500b99400e8d5c043cb3b2fd9e2312198af614f23d1c99274b802809"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "572994664d86a2abf9505e70949230fa17b613dc7e594425f58a21ea7eb749f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "073c663ddac4ba5e99753ce7e281dc9c3fc6d575cc8b4ef2490e6fa99cd1a6eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f5f09cae94b0d72be22b34cd17a879a15cf7e2d69460af1a384e82a30ef963e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c66e8a238ae7fe72ee07cb89113274e147d75519c5169a751d62104feda7d25b"
    sha256 cellar: :any_skip_relocation, ventura:        "b6d9b4efbd475c242879125f200dd62ce1a5ac036faa100a098c5b5b80e04084"
    sha256 cellar: :any_skip_relocation, monterey:       "029526e26902af6c10c161f6558b088f3eab0adebdcf6f0f10cd2abca092e053"
    sha256 cellar: :any_skip_relocation, big_sur:        "49eb05e9c24cbbfd4c8483046102211c865b95c218bce76269a48a3b5440584b"
    sha256 cellar: :any_skip_relocation, catalina:       "74c576492d6d3809831b378c382e885b05425eda763b280ab17fa5cafb222a08"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fba06bfb3b2ac0e4e9c5163d60477a6bd69719ea8f7c629d47ebce573cadaed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "119fff1c3e34608d859d79aef5a4958176a9685000f7686941bf6b26d5f3f5c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test/file1").write "brew test"
    (testpath/"test/file2").write "brew test"

    expected = <<~EOS
      2 Total files (with duplicates): 0 Kilobytes
      1 Total files (without duplicates): 0 Kilobytes
      0 Single instance files: 0 Kilobytes
      1 Shared instance files: 0 Kilobytes (2 instances)
      Standard results written to Results.txt
    EOS

    assert_equal expected, shell_output("#{bin}/ddh -d test")

    assert_match "Duplicates", (testpath/"Results.txt").read
  end
end
