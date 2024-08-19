class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https://github.com/RubyMetric/chsrc"
  url "https://github.com/RubyMetric/chsrc/archive/refs/tags/v0.1.7.3.tar.gz"
  sha256 "eb4f77f331fa9b1f0b2b213cf19e29a7d1dbd3ac5eb09b67023a3c4bdde617df"
  license "GPL-3.0-or-later"
  head "https://github.com/RubyMetric/chsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab3a3851dc9b91e031f3af79a17fd935efcf58a32892853d5a511dd2b12ecff0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a900254c197164142859424b33083abbc3b82b9571564e5ed98651bc8279d519"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ceda6817d904ff98bd554fefff84617337df2b8a8f6176d4f26fe66543cb169"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c2726a2b4b739593838868501eb826280504b6ed89968dc9d5ee183886aad64"
    sha256 cellar: :any_skip_relocation, ventura:        "677188a6e08ddba6446b5471c6ad4e883e61d82a645c453b200840ddb1918cda"
    sha256 cellar: :any_skip_relocation, monterey:       "fd1d14523da58109e0007ede278cb180c51fcb5a6c431b801278e9c25a112065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d41d27d3d3e70b3ca9a69bfc2dff39b7f1402aa21587caa261bcbf6d56f3bad3"
  end

  def install
    system "make"
    bin.install "chsrc"
  end

  test do
    assert_match(/mirrorz\s*MirrorZ.*MirrorZ/, shell_output("#{bin}/chsrc list"))
    assert_match version.to_s, shell_output("#{bin}/chsrc --version")
  end
end
