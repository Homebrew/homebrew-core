class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3810stable.tar.gz"
  version "3.81.0"
  sha256 "c9516e8ff541bec50c59ff363958793b92d28aa013365676f44e97615ff0754d"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "340313a0bd6c8cf6e43f32e21f507d92b2705099e7767c9196bb255f82a42894"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b0c719ea13089b279d027bcc927e4d8bd5b738fba13ab4a078be3f4d59ae103"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "674e84aa0cab62a01372cafed2f4765812d242eab43a09eab50d8c4bdc513cf8"
    sha256 cellar: :any_skip_relocation, sonoma:         "358a800eaf3b43e7c3d435d93d2f5dbefd952ac29bf0fd397aa145ee9a373448"
    sha256 cellar: :any_skip_relocation, ventura:        "c1ac4bfc0eb177ecf8f358db151602e519df1121763f946bfbe2a8550c3119b7"
    sha256 cellar: :any_skip_relocation, monterey:       "1b4ba242a6fb8bbb5162390cce73c5f2c741e9228892259862e08ac35e299555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ead419a99e212307780a55651b1950b4e96654355b2d4b0459bf90ced057c9"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
