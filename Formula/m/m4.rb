class M4 < Formula
  desc "Macro processing language"
  homepage "https://www.gnu.org/software/m4/"
  url "https://ftpmirror.gnu.org/gnu/m4/m4-1.4.20.tar.xz"
  mirror "https://ftp.gnu.org/gnu/m4/m4-1.4.20.tar.xz"
  sha256 "e236ea3a1ccf5f6c270b1c4bb60726f371fa49459a8eaaebc90b216b328daf2b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e53f47d0d6e20a4392d1d907c44e1bad20af6aaaa03f5f18fe18f0f980bc0780"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80bd9ecaa8798a7db6a2e86acc61089dc31d83e6e9e01495a6a57c3703155f47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d218aa1dbe24f70c8386a85aa8e95ffa1a4b875e3ce031061ac45541144f8cba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d2542fbf7937c71d36279c65313915039fc083dd831831f7b0a6a88caf0ed936"
    sha256 cellar: :any_skip_relocation, tahoe:         "b992bb0f970adfbca8ae89fc17a2bb30031e7697bcde67083051789194ffc599"
    sha256 cellar: :any_skip_relocation, sequoia:       "72ae6db69f54b605594324fbbd4f2d6f6d3317289518ce698c4de2b806ff1b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c949c70570c40706b0bf864e11ff646866072b59df94bd5a5b381b475a52137"
    sha256 cellar: :any_skip_relocation, ventura:       "11309d2a93df1a7f3aa467d99e2b7f210c5fd3a720831766d47b62e82a1a4068"
    sha256                               arm64_linux:   "8f051741304b492c0ea6cfc4826839c0076e4ef1e4801cf11573b28c20b1b410"
    sha256                               x86_64_linux:  "5f34f9a110c2abb1b32915cbacf6b9ecaddb2ff2438263047c59bb8636c6c220"
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Homebrew",
      pipe_output(bin/"m4", "define(TEST, Homebrew)\nTEST\n")
  end
end
