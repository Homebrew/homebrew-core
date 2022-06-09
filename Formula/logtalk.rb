class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3560stable.tar.gz"
  version "3.56.0"
  sha256 "6ae4dd335fbccc8a86c20ff84d2156608ddf5e6d9c0582934bb606ec065fc56b"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acba591c18cef092035ea0e3646624f712be1cf1feb9a0e45177980ace8de075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2644f3e3679b44512eab363afc4fe0a449d7db90861ac3a73557ea9c5a322fc1"
    sha256 cellar: :any_skip_relocation, monterey:       "598005ed81ef512d545dc9532a90a5ab4dfb266644974973843b1a3fcd5c8498"
    sha256 cellar: :any_skip_relocation, big_sur:        "b299db5ddfd0ce5cca0070e0922629ffd8ca6fa79c7f4c6e7a3ff27d102c2bba"
    sha256 cellar: :any_skip_relocation, catalina:       "ca333a915e5139f268a57e879f24cb4cc9e37a142d5dc9cb40312dc8889a23f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdf6652a04e7fea52cd9f484660dff390c4cd8d64ac3ffa23d1a3ade82950c8d"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
