class Afsctool < Formula
  desc "Utility for manipulating APFS and ZFS compressed files"
  homepage "https://brkirch.wordpress.com/afsctool/"
  url "https://github.com/RJVB/afsctool/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "5776ff5aaf05c513bead107536d9e98e6037019a0de8a1435cc9da89ea8d49b8"
  license all_of: ["GPL-3.0-only", "BSL-1.0"]
  head "https://github.com/RJVB/afsctool.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "551e9f8910b53ce228f1f710e100c54266cbed7ffa3a087ecec516c71bba5dbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9eab0e700160a5bf2d1f62f8e67a017280e10315030cb09134933ee782974a95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1596705cff076205b68f6fa301394e2feb6bdfc071543679db46aa38eec7aae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6528c95eb0a3b0b57a72eeb847ceab4e4887cbcbaf46a019f9e47d875b6deb9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54700cfb61f7a32df0346997ccb3a181e1b7bef7613ad8bee751b75aaab9500d"
    sha256 cellar: :any_skip_relocation, sonoma:         "74f60adb27bfbec7b4add84a60f73ae3d7c804632dd99a39b61c270bf8125e92"
    sha256 cellar: :any_skip_relocation, ventura:        "3f8835bb2dac636100454adb2262b8e86dbb394519dcd60f83ecbd39e21e6f17"
    sha256 cellar: :any_skip_relocation, monterey:       "17a9351748475089c170985080188c640209eab140e959808979260d752c254e"
  end

  depends_on "cmake" => :build
  depends_on "google-sparsehash" => :build
  depends_on "pkgconf" => :build
  depends_on :macos

  resource "lzfse" do
    url "https://github.com/lzfse/lzfse.git",
        revision: "e634ca58b4821d9f3d560cdc6df5dec02ffc93fd"
  end

  def install
    (buildpath/"src/private/lzfse").install resource("lzfse")
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/afsctool", "build/zfsctool"
  end

  test do
    path = testpath/"foo"
    sample = "A"*1024*1024
    path.write sample
    original_size = File.stat(path).blocks

    test_options = [[], ["-T", "LZFSE"]]
    test_options.each do |x|
      system bin/"afsctool", "-c", *x, path
      system bin/"afsctool", "-v", path
      raise "Did not compress" unless File.stat(path).blocks.between?(1, 10)

      system bin/"afsctool", "-d", path
      raise "Did not decompress" if File.stat(path).blocks != original_size
      raise "Data corruption" if path.read != sample
    end
  end
end
