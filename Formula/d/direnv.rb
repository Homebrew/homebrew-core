class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "6302f3eb824ae5f7d33475c6e9ac0ec46a228e282fca7dba881f3536575a25c8"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "ab0e6a6e1eb4470bdc3b32ef5624010001242093ec1373e31cfc6694f981807e"
    sha256 arm64_sonoma:  "1614b03afdfc3b3943c60930e4cbb9652592112ee10ecfc4e38f4d76fc174f30"
    sha256 arm64_ventura: "353e3c824dc3ad5ce5c18ecaa2d5dbc20edf48793d5fc6c6c007115bcefea824"
    sha256 sonoma:        "8ba4372e96900ec76857e8209df674234c153ca56af79e5936177309d8852c2b"
    sha256 ventura:       "04cb391732bdc57f76d69923ccc520c014ca6044bd7214bf8460ff5aecbc5ee4"
    sha256 x86_64_linux:  "2ce06e59279add063270e73e0e7b56d560a051ae134e088080d13ff11bd2f7f1"
  end

  depends_on "go" => :build
  depends_on "bash"

  def install
    system "make", "install", "PREFIX=#{prefix}", "BASH_PATH=#{Formula["bash"].opt_bin}/bash"
  end

  test do
    system bin/"direnv", "status"
  end
end
