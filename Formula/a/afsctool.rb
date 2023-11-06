class Afsctool < Formula
  desc "Utility for manipulating APFS and ZFS compressed files"
  homepage "https://brkirch.wordpress.com/afsctool/"
  url "https://github.com/RJVB/afsctool/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "5776ff5aaf05c513bead107536d9e98e6037019a0de8a1435cc9da89ea8d49b8"
  license all_of: ["GPL-3.0-only", "BSL-1.0"]
  head "https://github.com/RJVB/afsctool.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d67508020e1cfb83fc15f3497d556ae574310875401d46282f50a5ce0f6593b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f21804d2beead64d635cd72b2b9e5b76d1911dc2de9c15236e41689ddc46dc74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cee829a15d8fb035095298b056e8925c2ce5bf730c6ed7ac2e76df4f8432595"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05e5e2d51ff1fec526024bd93ba39d39afe230badd7e5bbe686df6e7ebf0fbab"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5b99585d0b2057c4ed61a3766641c986778fabf51b9ce2c83382289fb0e398d"
    sha256 cellar: :any_skip_relocation, ventura:        "9c972678aa3e291a0224c6e14cc90df0e29ccadd5cfafc895bb354b39b8a9e47"
    sha256 cellar: :any_skip_relocation, monterey:       "e13983fdbff0c188b976e8a0bdb49fcfadf83385bb65e96eb01381884cb40d60"
    sha256 cellar: :any_skip_relocation, big_sur:        "a225ce419105bddbb9fbd33d7ce67c500b2e571464a6b7f5f8792b73ce5aca59"
    sha256 cellar: :any_skip_relocation, catalina:       "588533fd0b1916a8b980983c87e603a8681a420c887c14fec5fcf7b90fbd6d9b"
  end

  depends_on "cmake" => :build
  depends_on "google-sparsehash" => :build
  depends_on "pkg-config" => :build
  depends_on :macos

  resource "lzfse" do
    url "https://github.com/lzfse/lzfse.git",
      revision: "e634ca58b4821d9f3d560cdc6df5dec02ffc93fd"
  end

  def install
    (buildpath/"src/private/lzfse").install resource("lzfse")
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    bin.install "afsctool"
    bin.install "zfsctool"
  end

  test do
    path = testpath/"foo"
    sample = "A"*1024*1024
    path.write sample
    original_size = File.stat(path).blocks

    test_options = [[], ["-T", "LZFSE"]]
    test_options.each do |x|
      system "#{bin}/afsctool", "-c", *x, path
      system "#{bin}/afsctool", "-v", path
      raise "Did not compress" unless File.stat(path).blocks.between?(1, 10)

      system "#{bin}/afsctool", "-d", path
      raise "Did not decompress" if File.stat(path).blocks != original_size
      raise "Data corruption" if path.read != sample
    end
  end
end
