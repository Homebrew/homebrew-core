class CernNdiff < Formula
  desc "Numerical diff tool"
  # NOTE: ndiff is a sub-project of Mad-X at the moment..
  homepage "https://mad.web.cern.ch/mad/"
  url "https://github.com/MethodicalAcceleratorDesign/MAD-X/archive/5.08.01.tar.gz"
  sha256 "89c943fcb474344a4f7d28de98e8eae0aec40f779bf908daff79043bf3520555"
  head "https://github.com/MethodicalAcceleratorDesign/MAD-X.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5be69f9b37beccf837408aa44a1a45310b9c3e01bd3ef03a82c2c44efc04489b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca09f09c648db2f72ad4aac482d6d367316a6604e299426b52909c493b54397a"
    sha256 cellar: :any_skip_relocation, monterey:       "3ab628d8b8b47efbafaafd6afc4cb4ff99f82308f9ccf6a092ce5197418e08e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e712813f8f8129ea33de11f286cd7fde8c0bd43793b74aaa406c3f1087180737"
    sha256 cellar: :any_skip_relocation, catalina:       "50b8142fe440dbb09037a8dc19d7ffb50cb3a03cd3bc4f9dc7b67cb168fbbf2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ecdcf5ec81411a6b738bd6175fbca7f2c34ba4680e30e3a12138dbd8ccd9e44"
  end

  depends_on "cmake" => :build

  def install
    cd "tools/numdiff" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"lhs.txt").write("0.0 2e-3 0.003")
    (testpath/"rhs.txt").write("1e-7 0.002 0.003")
    (testpath/"test.cfg").write("*   * abs=1e-6")
    system "#{bin}/ndiff", "lhs.txt", "rhs.txt", "test.cfg"
  end
end
