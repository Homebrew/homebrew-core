class Man2html < Formula
  desc "Convert nroff man pages to HTML"
  homepage "https://savannah.nongnu.org/projects/man2html/"
  url "https://www.mhonarc.org/release/misc/man2html3.0.1.tar.gz"
  mirror "https://distfiles.macports.org/man2html/man2html3.0.1.tar.gz"
  sha256 "a3dd7fdd80785c14c2f5fa54a59bf93ca5f86f026612f68770a0507a3d4e5a29"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.mhonarc.org/release/misc/"
    regex(/href=.*?man2html[._-]?v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "fb9e2bbd0ee79ffbfe8d88b22affee3ec6622df5d7275340dfb157b38dd8b15a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ecc7e32cd32d246ff8e3efc5061325d43178e0ed1f32847b501af7c394540483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57f83bcc5fc4cc1278e1e8fa671a51959ff91c4952a3a2da10f602c3331f141d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad45d9711383728beed965692eeff5cf47f26017c9a68254aa00af577e950c7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad45d9711383728beed965692eeff5cf47f26017c9a68254aa00af577e950c7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74778ca60783522eafd3f718104a650b2d3b9d6b3bf357c39990bfe669ba622a"
    sha256 cellar: :any_skip_relocation, sonoma:         "76a872bb8d19a508618c542676ca19cd871fa58f8f89308cd1d3cb5aef351798"
    sha256 cellar: :any_skip_relocation, ventura:        "52150cc353b92e2591decb511790b28c22921c11a5e716931e3c003f0c1ab5b6"
    sha256 cellar: :any_skip_relocation, monterey:       "52150cc353b92e2591decb511790b28c22921c11a5e716931e3c003f0c1ab5b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7c753526a25dfa4b3331da2129ff867199b9f4357e8c6b38d1df2d1c20c7886"
    sha256 cellar: :any_skip_relocation, catalina:       "760f302a2a8c5178b683688d47e7ec55b17bf85a51ee404b00b2a3eb02030fcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "168ef1ce0acff7648651cea049462261dc8111cd2207e80d42feeb090f927a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "481efdcde976cadff40796f063650a6926dff892b7e3753ee9cf65e669d8aab1"
  end

  def install
    bin.mkpath
    man1.mkpath
    system "/usr/bin/perl", "install.me", "-batch",
                            "-binpath", bin,
                            "-manpath", man
  end

  test do
    pipe_output(bin/"man2html", (man1/"man2html.1").read, 0)
  end
end
