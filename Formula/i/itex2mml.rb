# From: Jacques Distler <distler@golem.ph.utexas.edu>
# You can always find the latest version by checking
#    https://golem.ph.utexas.edu/~distler/code/itexToMML/view/head:/itex-src/itex2MML.h
# The corresponding versioned archive is
#    https://golem.ph.utexas.edu/~distler/blog/files/itexToMML-x.x.x.tar.gz

class Itex2mml < Formula
  desc "Text filter to convert itex equations to MathML"
  homepage "https://golem.ph.utexas.edu/~distler/blog/itex2MML.html"
  url "https://golem.ph.utexas.edu/~distler/blog/files/itexToMML-1.6.1.tar.gz"
  sha256 "3ef2572aa3421cf4d12321905c9c3f6b68911c3c9283483b7a554007010be55f"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url :homepage
    regex(%r{<b>\s*Current itex2MML Version:\s*</b>\s*(\d+(?:\.\d+)+)[\s(<]}im)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9927eb95f7d9d7dddfc7c684ca069bfa8b612c519461ef5233aa54098b9ea8d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7218674b662a6415899e7eb4dc00ac2634c60837b7a4b9fa7a4019cf668d8890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d58887108a80df9633a6d0740d9c7c8e630ca95f440878d2b75bcd1ac626951"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21fbfa1382c97a13c162899ec72451dccf4d9a4c368c3c0a3fc5e70db4173497"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f08478f4813d052ae7d98339582ca05b95674d7b08a254305bf8e4e6575b3327"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a13992add208a7ab179fab850b3aba9a18a672dd803247ccde9c225103edf01"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7fc486174a242a55b26291f5bb37abb96457788b66b3adcbe89291179f8edaf"
    sha256 cellar: :any_skip_relocation, ventura:        "e54abed4dd08fd6edf1b19812617d7ec4c3d94a4619c36172579b3a32f04351a"
    sha256 cellar: :any_skip_relocation, monterey:       "fa3e744eb8281aba061785ebb783c1a55d7f4a85c00787052a309411af702583"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cf7d88d4e102acb646f5e23a4bc168a50c19ce8bda26011bd25c7d8208dbb86"
    sha256 cellar: :any_skip_relocation, catalina:       "a4a3f1a4d8ff096ed6a4e1eb6ac2883d916de6504496cd8da929081484ab65c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "abef6379fe470feb9877993e8e9392c51bce8f9006b3d9de2e28c5c2b110cd03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "809bf39b25611efdd6f0c297918b0376788c1a4f380a69489b1e4495bd19821e"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    bin.mkpath
    cd "itex-src" do
      system "make"
      system "make", "install", "prefix=#{prefix}", "BINDIR=#{bin}"
    end
  end

  test do
    input = "$f(x)$"
    output = "<math xmlns='http://www.w3.org/1998/Math/MathML' display='inline'><semantics><mrow>" \
             "<mi>f</mi><mo stretchy=\"false\">(</mo><mi>x</mi><mo stretchy=\"false\">)</mo></mrow>" \
             "<annotation encoding='application/x-tex'>f(x)</annotation></semantics></math>"
    assert_equal output, pipe_output("#{bin}/itex2MML", input)
  end
end
