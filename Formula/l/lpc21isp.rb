class Lpc21isp < Formula
  desc "In-circuit programming (ISP) tool for several NXP microcontrollers"
  homepage "https://lpc21isp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/lpc21isp/lpc21isp/1.97/lpc21isp_197.tar.gz"
  version "1.97"
  sha256 "9f7d80382e4b70bfa4200233466f29f73a36fea7dc604e32f05b9aa69ef591dc"
  license "LGPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e9869885d3e10505fb16dd89ef1b5047a77e0b8a4231b9acb7f94c0da9099ea0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dc0f9ced6f8764ed8c4b7502ea6a4643621c3a4694530fbb9cfa02378b5ac760"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7c6c595025ea9682779d982ece6f0bd5038a5e1284724aba37f93274ef35077"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ab5cc792a65bd498458aa93dc79e77e921c2cff17e1f17629915332b4e4134b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df672a0be96a7703b2f4ff5db9c8c5b322de22822ea0fc6749becea3d3a0cc21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6f26711684bfbf3ddde4574aab70336278338b206a5fe3e278d868903bd8910"
    sha256 cellar: :any_skip_relocation, sonoma:         "44b03359d767803f0f50dadc0dbc1c4ddaae4b320018328b53e5d7bf314d43bf"
    sha256 cellar: :any_skip_relocation, ventura:        "5f30330abb1e75c57fdbfe0177bda58a25c64598a8af7d008d04cfcbc930d6f0"
    sha256 cellar: :any_skip_relocation, monterey:       "60c1dfa18f24845046fd13390aab73665d086859831c999a75bed2dbb37d902f"
    sha256 cellar: :any_skip_relocation, big_sur:        "47edc941f73249c62b66a4d795bcec7c2916082ab60f1cc1e1c0c46ebe99b694"
    sha256 cellar: :any_skip_relocation, catalina:       "e5231b41e3d08d835d4c3a457b594c60576c42802347c01555acc94c04067d94"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2d7b449d040a4108099e8d6569fed602400b95b762da98e134867185b3d6419b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b431e013e9df59ee8888f46bc8b972285c7f4c7d559c7441162179d7d920f66"
  end

  def install
    system "make"
    bin.install ["lpc21isp"]
  end
end
