class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3760stable.tar.gz"
  version "3.76.0"
  sha256 "8fe4083df70b6b4ee4b8e5565355c5a44dd0e6fb50f016d4502ed5d3ef3b460b"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff31fa1f39145e780e9e4f11fb89d12c0d8b7ceb27118ee7ed5429ffc0a48c56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fbd94d022abe67aa45c10ed82fa644c0b2623a467381ddf308a5478dd5b8e3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "246e3915480b938bcd059fe82152e32b41fd74aa6cb0c05b8bcf0dc81ab32dd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "bba9e230d4e244817370197ba9b371f0971edfcec62785a5a88ad17b98f49579"
    sha256 cellar: :any_skip_relocation, ventura:        "17a66a9c103386b5fb1a1a0315590ef116a830dc2894fcd58320aa4f37ce1d28"
    sha256 cellar: :any_skip_relocation, monterey:       "0c6c9b48a46d64f1f7ba91eab72bc92ca9bd48fce6a882e1e271a58affc11787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44f67505a11abcd0bf0958b19dc70dd9df73f9252fbc40df9582f30966a36a64"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
