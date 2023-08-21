class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3680stable.tar.gz"
  version "3.68.0"
  sha256 "5847625da312c3edcc2d8c9e51f6e9c0e3d0add277d916465e965a90b1a21318"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2a005ac23ca2ddd558ea3574b2624f88e53d909673de001de46d36de0ebcdf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01d43d497e3a26e24f27f32585cf4838200323d6385b74fdc728c139a8e9b516"
    sha256 cellar: :any_skip_relocation, ventura:        "1688dfd855fdf4fc824aa8b3336a25589c01fdb99ce92cf4c22a7ca69190f4c6"
    sha256 cellar: :any_skip_relocation, monterey:       "b5baeb82d4ffd4abf41b37919a3e83274218c5deaaf11ef9199dbbe3a2215644"
    sha256 cellar: :any_skip_relocation, big_sur:        "888be2fa98d1c872c5f88a31e8d7097ebd4f20cc9f119711afad7806d1646b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae99859bdcca99b4e259cff1869833c51083abd3a4d09c99ba745f40e3f3fde6"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
