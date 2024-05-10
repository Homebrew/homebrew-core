class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3780stable.tar.gz"
  version "3.78.0"
  sha256 "192571b170f20c3ba43013242b330de555c813cec10841832548beb8bd184fc1"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ebf523d70e25d41e6f49a14202fbadc6841e1c3ae32735e0ffdd8d6ce2bec0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e1757617e825a00a5ee93cb866a79e23e2c5db0c3db20a3c8c220286035dd63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb394fc9647558bfa6bed9b9e1f781df88a5103c8ecace89181b47f6c2b64893"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b50087cc7ef041cdd9f7293c848a7d10d01ab8f9f7fe42784b8ff9e4772fba4"
    sha256 cellar: :any_skip_relocation, ventura:        "ab37ab4bf13794700288359da3bafa5c1a540bb4891c58c98f5af302fb37c67b"
    sha256 cellar: :any_skip_relocation, monterey:       "3aae2e5b66cf72e022fde88e4b32d6ff70a65ad28fcd6f29a4afa75853f0cd59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d415a34e3a9289524e8222b66d9771c3664b8268da2b1faaf56cd8dadb433d70"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
