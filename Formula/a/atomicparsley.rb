class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/refs/tags/20240608.083822.1ed9031.tar.gz"
  version "20240608.083822.1ed9031"
  sha256 "5bc9ac931a637ced65543094fa02f50dde74daae6c8800a63805719d65e5145e"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "eb06745bb021400165dff5d9c34273fcbe02a430686c6075df36d1828c09261f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8a224c8a6e91bac8c95b78e70797b63f260e0958cb724e2884868b7720739f93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f08cfa8a20add56a8a17d2356dccdfd59065dc969e6d3fc1ede0978d46185f9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05d19096d14878111b050374bbdafcc19cb453c068cd24106766edb5e6889d6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb99a7c912436b15676ed135f18c3e687eeef23b4dc2f92c962f40c6ec4aae19"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ef3fb9321dfd7ac580239b39e67a580553083f4538823b1ad498e1a20521551"
    sha256 cellar: :any_skip_relocation, ventura:        "e09ac5b05a2227b03567097e8ff3e39f4f12a929b86207a4ac0873eb6578e43d"
    sha256 cellar: :any_skip_relocation, monterey:       "9d119a39c122e416e2e089fbcc2dd9714fc1a9c182c258b0b5a512b793dbae79"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3ddacba6d9783f732895ac6ffa41167aacbecaea081f7efa36702a0a1a72debc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71ecbada94798344e79eb385528e9b598767297a70beb6246d4bb1b29aaf77bd"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/AtomicParsley"
  end

  test do
    cp test_fixtures("test.m4a"), testpath/"file.m4a"

    system bin/"AtomicParsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/AtomicParsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end
