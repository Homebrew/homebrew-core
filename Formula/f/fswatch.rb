class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.19.1/fswatch-1.19.1.tar.gz"
  sha256 "b8736d41b6f108c8089ae38361ea9bdb035445caac3dcb413702bc567a42a91a"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b4731e9b2ef6304087d9366073093b672f4809e446c2a99accfb1e39d79e3d08"
    sha256 cellar: :any, arm64_sequoia: "0f18b4fd676f65fe80cb5005b2ee94ef0958d208632133527c2f8345f5478821"
    sha256 cellar: :any, arm64_sonoma:  "60925a138619dc65784c6db480bc6755f8aafcfb1fc9423966bef1a408ac300d"
    sha256 cellar: :any, sonoma:        "698b0faa3858f897e5b7a4fd5f72fe13f9045c59d0279917a16b664eaf0e0a55"
    sha256               arm64_linux:   "3699705c7fc07f95d6cf19da66b55c555dc0f37629e215ad47b0880bf673ea5b"
    sha256               x86_64_linux:  "ab75c570dcf1a8b8684a8c03b8af3bc8abfb9820427ec672d703ac71d6dded3d"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
