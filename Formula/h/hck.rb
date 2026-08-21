class Hck < Formula
  desc "Sharp cut(1) clone"
  homepage "https://github.com/sstadick/hck"
  url "https://github.com/sstadick/hck/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "b9821c4de35308d8d1d9e979da39f8a7effd82d2e0b1f4f7b1c83bc48ab8da20"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/sstadick/hck.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a299fca862a0c6622dcae57a753cb411b0d6a39d8b0769a52ad513d631bf0ae4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b3f4dca28753b43601bceed0990a538e717206e5193f7387443b5771da00521"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c4c249c67fd2db07f550538dc2b3ad5aec7b43a434204c3d185971a7fab85b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "156411d96f2a679b84308e77137edcba0d5bd73c5f026261e420c71f7397891e"
    sha256 cellar: :any,                 arm64_linux:   "124ab1103933fabc1a81cf28d307511ec3e8894f99e3298d65a08dc9c6cad122"
    sha256 cellar: :any,                 x86_64_linux:  "daf36e53a6ad18ea2ecca1f86de5d4fca246f9cf5910b74c5a0a8a7cae58457c"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/hck -d, -D: -f3 -F 'a'", "a,b,c,d,e\n1,2,3,4,5\n")
    expected = <<~EOS
      a:c
      1:3
    EOS
    assert_equal expected, output

    assert_match version.to_s, shell_output("#{bin}/hck --version")
  end
end
