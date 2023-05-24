class Leetup < Formula
  desc "Command-line tool to solve Leetcode problems"
  homepage "https://github.com/dragfire/leetup"
  url "https://github.com/dragfire/leetup/archive/v1.2.0.tar.gz"
  sha256 "d4c424d994531ed034c264611774ae258f499ee9819061c49ece1321bb96434d"
  license "MIT"
  head "https://github.com/dragfire/leetup.git", branch: "master"

  # This repository also contains tags with a trailing letter (e.g., `0.1.5-d`)
  # but it's unclear whether these are stable. If this situation clears up in
  # the future, we may need to modify this to use a regex that also captures
  # the trailing text (i.e., `/^v?(\d+(?:\.\d+)+(?:[._-][a-z])?)$/i`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cb6b79c2c9a64149f91a259d62c7e327f30c523385db8c8d7dbc572cdf24332"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "723100f866721b6c8fb7417084e2496e1d68f3fc09ad2b26382781efc11fb82b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9690647835bfade04169b89f477dc310a872487cd32836706f6bc37d83788a47"
    sha256 cellar: :any_skip_relocation, ventura:        "f393756f6886ec72181eadfb0f546e520d613dc897a658d3c50b9c88614c4c8d"
    sha256 cellar: :any_skip_relocation, monterey:       "931ee49f796084d159b3e92ac3c1a2bc9b38bc1fce76fd99e4c77c1c7a8dc5f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c0137b2499d6c3c13af9bfd17aa1c77d7640244b447632d1072d937bd3ae2bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a88fa3418b7ded7a3f3b3e23cef5265e75d0b1e94baab86d2796ada55a3656bd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Easy", shell_output("#{bin}/leetup list 'Two Sum'")
  end
end
