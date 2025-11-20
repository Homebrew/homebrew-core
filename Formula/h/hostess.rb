class Hostess < Formula
  desc "Idempotent command-line utility for managing your /etc/hosts file"
  homepage "https://github.com/cbednarski/hostess"
  url "https://github.com/cbednarski/hostess/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "ece52d72e9e886e5cc877379b94c7d8fe6ba5e22ab823ef41b66015e5326da87"
  license "MIT"
  head "https://github.com/cbednarski/hostess.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "421dcd7d0df30a8b2d781558f9b8e5c5d6bd743351afe1e6798b5ce5632749c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5af8f3803260637b3938948d0a18cf210279b7cd6b6abeb9e197e373feb5a53f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0186aaf7affa768a218d00dc949003d663a5e13c0282c2b95b18135070254118"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70fb5d0bdf6c6c22082affae3027953e8c59d51a795bd6983b30a58fecf5088c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "277bc64d736ab7413d771e469943d1037b196e6b3aafd987a5c09602ada6b499"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4272e75f8cba2d02e038dca00f7620a70ca396f3486aaf57a6a9fde77645c562"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9161d0f8c9609bbbca83aaf95f6042c28f71e376d7af4b66d119d8a3d68b184"
    sha256 cellar: :any_skip_relocation, ventura:        "a0cf169ccb1606629100606c6326aeccb72447e6f3447dd018814c4423f8f07e"
    sha256 cellar: :any_skip_relocation, monterey:       "02d6c4ebd1fb5d414bde215becf8c8c69c1a7b7d9561ca19c270f3c2da2e904b"
    sha256 cellar: :any_skip_relocation, big_sur:        "addb5bc6b7ff84ad6d2a33f2e0c46298f16865473ad82a32c02434def068c26b"
    sha256 cellar: :any_skip_relocation, catalina:       "9386f4841bb16ea44d5131b0a360138a3d33d7595e85d0baba3b9546762d7ae6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "12cd00ad6a0eee2e772ea60131eb700fff31d6c6484b6c565347c99f386fae10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0b57a734d8f4d98281726dfa821ff8b2dac02cfdfcd2349000257bdaf614cd6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "localhost", shell_output("#{bin}/hostess ls 2>&1")
  end
end
