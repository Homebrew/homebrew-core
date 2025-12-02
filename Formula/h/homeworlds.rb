class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3ffbad58943127850047ef144a572f6cc84fd1ec2d29dad1f118db75419bf600"
  license "BSD-2-Clause"
  revision 2
  version_scheme 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f74bc37a6b17871ff8c413e2fb899cabdda55690e6983427290529793406d840"
    sha256 cellar: :any,                 arm64_sequoia: "768658afe4a3f11e530bc1cd5110a439e5d5e58648d03d1b2c8ac2857888beaf"
    sha256 cellar: :any,                 arm64_sonoma:  "9ce5c68b19b966fe5d40595ad13eaab04965fc642cfef3c1427bf2172d217c0b"
    sha256 cellar: :any,                 arm64_ventura: "f144b8b232721d3066ea19ef5fdad02b9a84d34bbab0d18e5f5a640871cc5d91"
    sha256 cellar: :any,                 sonoma:        "0f4b28079d38039fd32ce0d4aff4d0cbd96fb717f91247f55f5f1a26d9c323b9"
    sha256 cellar: :any,                 ventura:       "0d72a5a3f12c4de35510a887f47b618e89f036a15421314d7c62cd641d79861b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba01b47b31f0771b43573cdf381345b0a775410dc0392583e70f344e9f9de523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7469baca1596a7e92483d24f43b3ef0749d209e2832300a4de9dfe9fa3d86e7"
  end

  depends_on "wxwidgets"

  def install
    system "make", "homeworlds-cli", "homeworlds-wx"
    bin.install "homeworlds-cli", "homeworlds-wx"
  end

  test do
    output = shell_output(bin/"homeworlds-cli", 1)
    assert_match "Error: Incorrect command-line arguments", output
  end
end
