class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.17.0/fswatch-1.17.0.tar.gz"
  sha256 "988d9fca774eb9b2d1b3575ef56c5ce7fdcc718dbabaf727178651eac11bdabc"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "91748b16bf63b64ddd0d388fdb2da055b536a4ff3ff0765e4ba03fd5149b4a6c"
    sha256 cellar: :any, arm64_big_sur:  "220bbb702c2bd76ddbe1547368e3e6adaeb7a6e3642265b2bf663007787e4fca"
    sha256 cellar: :any, monterey:       "0f086fbed007ce65e76beb344b7140426fd78ead5dc49bb41f990ff68c911fa0"
    sha256 cellar: :any, big_sur:        "3ff1a1373e2918d6ae8615ba6db2b5ddf449acf99c8e0cc5a917b86bc7cb2bdb"
    sha256 cellar: :any, catalina:       "1030176db64c0babafed0055afc1740b96372ef801b31a4f6e74178a5adab0fb"
    sha256               x86_64_linux:   "68ec0add9fda7ef354233a32495c2ba9d58734e7970fd2dcd4948185cdb0d5af"
  end

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
