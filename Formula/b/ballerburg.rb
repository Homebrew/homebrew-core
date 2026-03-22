class Ballerburg < Formula
  desc "Castle combat game"
  homepage "https://baller.frama.io/"
  url "https://framagit.org/baller/ballerburg/-/archive/v1.2.3/ballerburg-v1.2.3.tar.bz2"
  sha256 "2e55087c70e10a827a270493732d3928f8fb0abb6b583661f80cbbe1efac80f7"
  license "GPL-3.0-or-later"
  head "https://framagit.org/baller/ballerburg.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cccde44114f408fbef049352adf60ffd2bfcdca158cde6b665cbbf03801daaa6"
    sha256 cellar: :any,                 arm64_sequoia: "dd778359cebe62952c33d6a2e5c2274f7e4784ccc9f02dd86ca15bb783487608"
    sha256 cellar: :any,                 arm64_sonoma:  "bf505c27f0af03d53a92ef5816d66ccaf2843ef65cfb59aec887a5ec0c1f7a57"
    sha256 cellar: :any,                 arm64_ventura: "1c01a6a26ad1acfef28ad833391a9d004a2a70d8d97e6e5a475f26210c2bf43c"
    sha256 cellar: :any,                 sonoma:        "29c01bc593a8279839cee765f58ec00e8e7e52486099f8309b97b5f493e45e11"
    sha256 cellar: :any,                 ventura:       "ee583b89ffe454e9c550860d852333d5f91c23155c426c384727dfd1f689a0fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a7a8a678f0f6cdaf859468a93da5ef49d5a1aa095fbec77e7d1bf5184163dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aa85f3ee1fc21cda5916659e10333c563cd918356d3eca5016847a48ff03e57"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end
end
