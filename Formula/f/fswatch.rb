class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://emcrisostomo.github.io/fswatch/"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.22.0/fswatch-1.22.0.tar.gz"
  sha256 "fa6e2becba0a629964b466b39c5997e72d8a6da40d82b88190aae7359065c758"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2a9949350ec1c5af3e58265890fbae04a6040c2efc41bce741a30879a88780e9"
    sha256 cellar: :any, arm64_sequoia: "a8f67a63445642832e4b7b109ff95b35ca7b615d3f421e8adb8638431ba05d63"
    sha256 cellar: :any, arm64_sonoma:  "060a8cac22be34dec61dcd2b9632a5dd88bf11795c765194fe9cc6f1ab051eee"
    sha256 cellar: :any, sonoma:        "769d99e72f0a961f8d3265cc1e7b00428b5366d410303d18cf89f1771979e66a"
    sha256               arm64_linux:   "816fae1e6d22964fb117f46972df5036cbf25e21c6a01231be8dc7a772de2b0d"
    sha256               x86_64_linux:  "630eb329e9ecf3a9dd216df41f8ced6c03a7d4485e2954772e0831934565d94f"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
