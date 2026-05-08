class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.20.1/fswatch-1.20.1.tar.gz"
  sha256 "890c2d7c53f4e05726d891e6211e6700d5724d6a4d29055282bb849f6eaae227"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9c22d6f15ef6ebebe099a3aa7ad5a2b68b9f3e1990efcbaddda62000330df0b7"
    sha256 cellar: :any, arm64_sequoia: "aaddeb1580768fb6b821a8c986555b675d5e9e95642362dbcea3ccc487a8e02b"
    sha256 cellar: :any, arm64_sonoma:  "e618bc051d3f2f04ae4ad112a994b9cf9d4ca92362c9b9dfbcb2421523829b30"
    sha256 cellar: :any, sonoma:        "481776471ff39e1ccafeda96122fdb91b9dbfd73d8a0581823f60b586cc36fe3"
    sha256               arm64_linux:   "92f534a0844ea54ad919a154805dc9d01f0ed95d46895d7267e2d97326e0b933"
    sha256               x86_64_linux:  "df6f5b3ec34eef0ec5719395c3cc2c1fa699042ed3f8c014b791de6c3e4e5e1a"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
