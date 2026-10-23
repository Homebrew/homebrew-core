
class Balance < Formula
  desc "Terminal-based encrypted messenger"
  homepage "https://github.com/qoddit/balance"
  url "https://github.com/qoddit/balance/archive/refs/tags/beta-0.3.3-osx_only.tar.gz"
  version "0.3.3"
  sha256 "16bac446367e405d4bf93a91000ac6f40deffe6a174a17fcc17b8f8dd6047d94"
  license "AGPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on "ncurses"
  depends_on "openssl@3"

  def install
    openssl = Formula["openssl@3"].opt_prefix
    curl = Formula["curl"].opt_prefix
    ncurses = Formula["ncurses"].opt_prefix

    system "cmake", "-S", ".", "-B", "build",
           *std_cmake_args,
           "-DOPENSSL_ROOT_DIR=#{openssl}",
           "-DCURL_ROOT=#{curl}",
           "-DCMAKE_PREFIX_PATH=#{openssl};#{curl};#{ncurses}"

    system "cmake", "--build", "build", "--parallel"
    system "cmake", "--install", "build", "--prefix", prefix
  end

  test do
    assert_predicate bin/"balance", :executable?
    assert_predicate bin/"balance-server", :executable?
  end
end
