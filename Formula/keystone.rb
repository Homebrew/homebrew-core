class Keystone < Formula
  desc "Assembler framework: Core + bindings"
  homepage "https://www.keystone-engine.org/"
  url "https://github.com/keystone-engine/keystone/archive/0.9.2.tar.gz"
  sha256 "c9b3a343ed3e05ee168d29daf89820aff9effb2c74c6803c2d9e21d55b5b7c24"
  license "GPL-2.0"
  head "https://github.com/keystone-engine/keystone.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "743215d19932a0fe1e4f806efa17149fff3a0b9c3b391733284204f73ea750f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26b09a5083cf57b1004ad52ce590d1a6a0a4208d59176d40ec39d1be65377353"
    sha256 cellar: :any_skip_relocation, monterey:       "7dacd24322aefed03a8537dc60cda57f5d164e801367ba942588fc9d862c3a50"
    sha256 cellar: :any_skip_relocation, big_sur:        "2274b6cf90bf0b1b49d3aa6e0a527911e71438903c228bfd37644d58ac3ad22d"
    sha256 cellar: :any_skip_relocation, catalina:       "84cdef2aa8a5697ce2fc62e6ae1316f2dcca6fcd0f92d2bba68b399af9c48440"
    sha256 cellar: :any_skip_relocation, mojave:         "814feeee85e111a21fdd287fbed3fca3e1cd86be396dcba7612c3e1aec7dd4d3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "77740af9b9e48baaf0a7d1dc4d74b883c1babbaab6a7e9bf65a00035b59c546d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf07b840547fc8884f1bca89610cd0012fcb29390d6556acaa2ead6b5be0a256"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal "nop = [ 90 ]", shell_output("#{bin}/kstool x16 nop").strip
  end
end
