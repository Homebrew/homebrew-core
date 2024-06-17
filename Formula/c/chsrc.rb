class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https://github.com/RubyMetric/chsrc"
  url "https://github.com/RubyMetric/chsrc/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "e5b64922154262eda7d17af7ecd297278bd2c4134a5f385e0e9807eb27020de9"
  license "GPL-3.0-or-later"
  head "https://github.com/RubyMetric/chsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12fd3a489f497e2ca04c58b5bff5ac026c74dd4ef6a459558b12894d08d27fc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4be864f1d6dbb6ca81550ef6b565435fdcbcffdcd4861aa1cec3e5d13ee1d9f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0708f2a35c06f7aaba8e08762b68881ca318c69bd0ab46b0e99d88117a1e7b82"
    sha256 cellar: :any_skip_relocation, sonoma:         "70d6efa1fbd10411703d090a4369b8625196a0d5a649dc75f1d1373e177c7553"
    sha256 cellar: :any_skip_relocation, ventura:        "c76576fde6b6303def507ac705ad438d1dfeeecc37ff2c9833733da3dba6d41b"
    sha256 cellar: :any_skip_relocation, monterey:       "6772faaebd7b43fc4801ad54e8b04742e7689fbfdaac64c3c8fcd087bb23ff95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52e375710393dcd4b596be0f188c9f62419a34097d3764c0ef9b5d1ce5e39461"
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
