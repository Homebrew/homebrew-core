class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.18.3/fswatch-1.18.3.tar.gz"
  sha256 "08b13c0e0f92bd5eee5a310bb58fc373f0cda8304f9decc34cfabc42adf8e9ca"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8172ca1617fd1842b1268e21c501568d754aa38c44814a60a146316b5683b07b"
    sha256 cellar: :any, arm64_sequoia: "9102bd9bbc2986d33198018ff5835f016adfeddf19663cb1a32f5e8b458c21ad"
    sha256 cellar: :any, arm64_sonoma:  "65b94418058631c8c8d3a3d3b7e3fa83afbd783eab51685fff7e890914fbb085"
    sha256 cellar: :any, arm64_ventura: "986e62e77df8976fb7fbfc3191884e8bb9099be083f3f9f24068d8fe71c841f9"
    sha256 cellar: :any, sonoma:        "91e198310bdd2d8b35707ff94cf6994b7d903a1eb3bc59b4bfaa5a95f59dbf97"
    sha256 cellar: :any, ventura:       "2ee6553a2a11050422b056793a83ab3eb0e0e52bd7d3a0218352dbd6277f22ec"
    sha256               arm64_linux:   "28847e0988e7273c44f2fd0d973f72bb54f1b31eb28cc29e99bc7570f8522e8a"
    sha256               x86_64_linux:  "5551e2ed7bd36248bbf92916bbb1dc193e15963aab05cce5819ed270309ff3af"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
