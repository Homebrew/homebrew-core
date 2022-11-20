class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-639.zip"
  version "1.6.0-639"
  sha256 "3c6be48e38e142cf9b7d9ff2713e84db4e39e544a16c6b496a6c855f0b99cc56"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "120f556d4e9837ee4a35978c6f7cc3867aae7cf9b65c5b6180a14c90c2471034"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f62e19d2852307115f0c1e94b213bc9077181de58cf7e903c4b795d4cfbd6888"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2358cfdfb419baa21fa6e755c9b3934e95ec3b98abb9be232b57246a3afd870"
    sha256 cellar: :any_skip_relocation, ventura:        "1bab88fe219d33c4d70d3b3f8559c7e9b7470c0252706bd8f1d9d14208f04b7d"
    sha256 cellar: :any_skip_relocation, monterey:       "cc5bdd3454e526f4c0b365c4a2edc12ab5a16103b4681cddf79bb3d09c925dcf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dd938966ebb32156e7c59c80adc0278cd025b145c606db5762b05f41307d2c0"
    sha256 cellar: :any_skip_relocation, catalina:       "168426e4c986c10d06e576cdf25081d5bd5530645c57eeffac741a04b8f5ae80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a911a1119727f07322db89b2ec133aabd98419ee9fe450ac06b92638ee084c08"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10"

  conflicts_with "gpac", because: "both install `mp42ts` binaries"
  conflicts_with "mp4v2", because: "both install `mp4extract` and `mp4info` binaries"

  # Add support for cmake install.
  # TODO: Remove in the next release.
  patch do
    url "https://github.com/axiomatic-systems/Bento4/commit/ba95f55c495c4c34c75a95de843acfa00f6afe24.patch?full_index=1"
    sha256 "ba5984a122fd3971b40f74f1bb5942c34eeafb98641c32649bbdf5fe574256c5"
  end

  def install
    system "cmake", "-S", ".", "-B", "cmakebuild", *std_cmake_args
    system "cmake", "--build", "cmakebuild"
    system "cmake", "--install", "cmakebuild"

    rm Dir["Source/Python/wrappers/*.bat"]
    inreplace Dir["Source/Python/wrappers/*"],
              "BASEDIR=$(dirname $0)", "BASEDIR=#{libexec}/Python/wrappers"
    libexec.install "Source/Python"
    bin.install_symlink Dir[libexec/"Python/wrappers/*"]
  end

  test do
    system "#{bin}/mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_predicate testpath/"out.mp4", :exist?, "Failed to create out.mp4!"
  end
end
