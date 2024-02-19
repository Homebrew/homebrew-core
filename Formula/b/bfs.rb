class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/refs/tags/3.1.1.tar.gz"
  sha256 "d73f345c1021e0630e0db930a3fa68dd1f968833037d8471ee1096e5040bf91b"
  license "0BSD"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "22ef8af372591d6cd49277ddbf065b3f32eef93b315c412b3989ce982a3b3df8"
    sha256 cellar: :any,                 arm64_ventura:  "5c9c6b0c17ad6dffb6556557ee8b1d18b05499b2e1976779c0f6c3e2d8c75720"
    sha256 cellar: :any,                 arm64_monterey: "04a17acc5f452ddfe9f3373767d151a9dff24b46cbc9f11c798f453a3598bab8"
    sha256 cellar: :any,                 sonoma:         "61131b335fa16e2981d5a595c90851cd5fc0a57fa7a5b0565bf565795141f1d8"
    sha256 cellar: :any,                 ventura:        "3a9c1746a55cf856edad605647ec4b086c23f2f22e36c9a3a5fa5db8d02940a9"
    sha256 cellar: :any,                 monterey:       "3a37f0499b4c2eaa911451fc0a55a74e7895b3579b48cbe09747ba28bbf61f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e714ea73ad0ff05263af185419ec9f4b5e738047d9c2c32e145ca2c03770f72"
  end

  depends_on "oniguruma"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
    depends_on "liburing"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    system "make", "release"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/bfs -name 'test*' -depth 1").chomp
  end
end
