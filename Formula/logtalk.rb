class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3640stable.tar.gz"
  version "3.64.0"
  sha256 "66318c4762e288465d915a607da40440d645c02a82925883a61f2429609e87a4"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcbfd94a0895b951303124de7c436183d67d4f075f71cf4aa8512866be1580f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd8d106afbdcfaaf4a0304c0507494182ea93705c4a4015a77771aba97099c84"
    sha256 cellar: :any_skip_relocation, monterey:       "e1ec869e65a06f04f8b9562f10dfd68e71a3d02343dc41d9e7ade973bacd12dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1ec869e65a06f04f8b9562f10dfd68e71a3d02343dc41d9e7ade973bacd12dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d31c5db669a504c902f017af72e2e95fec648b106374e4291311e23d5808c309"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
