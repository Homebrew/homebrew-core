class Chsrc < Formula
  desc "Change Source for every software on every platform from the command-line"
  homepage "https://github.com/RubyMetric/chsrc"
  url "https://github.com/RubyMetric/chsrc/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "da4f5bb6b1a60e4b1dc31c72f24ede3f5b5c3072193c3fe419b713dc047a5b38"
  license "GPL-3.0-or-later"
  head "https://github.com/RubyMetric/chsrc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6538d980b8056e0ae50bbbaa3f3fc7926e93303e97f530fbc99d5cf7db267130"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8c2dcdb83db2589a276de026d0fa060df9835aac691ff30dd15a1a05f80987f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56302b8e229544e1718d0a162f46dd7cd551afba959210e1a8a2838dc38930d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "da991fd5b4180d68fad018f34fad40c341402cc87eaf309d75193ac723177cbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "363779f379bf4a3f951c687bd29b00c93b1f41e5b45e9e3659b8bec62e709257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ff3ec3759c3784202584f4fb1c7d778eb201a918dd09480068fb0debfe5aab3"
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
