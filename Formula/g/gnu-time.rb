class GnuTime < Formula
  desc "GNU implementation of time utility"
  homepage "https://www.gnu.org/software/time/"
  url "https://ftpmirror.gnu.org/gnu/time/time-1.9.tar.gz"
  mirror "https://ftp.gnu.org/gnu/time/time-1.9.tar.gz"
  sha256 "fbacf0c81e62429df3e33bda4cee38756604f18e01d977338e23306a3e3b521e"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "feac0744561e6ed40145815079575f4066bb3f8c363d1c9fc2302fde2f93b7bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "963acabedfade9cea9496798c8b026794762de08137f791c778e128310fcb1ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77a541727f4a75443a930e18391ed483b0a3fc797876376a0f7b34260db9a88d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5015e7e94a474156cdc47fb188143388231916979598f5398b72e79393a2000"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff4691a2d76432eb0222284ccbeda79b3375cefdb1c606ba74ea3e8e06ac25f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3930463651363f08ca7a90ec25deafd85c57f7a71be8ee236f7e15f20de7ff22"
    sha256 cellar: :any_skip_relocation, sonoma:         "99cb9faea67317bef1bd531f810c91b4f77817d127942ba3902dcc8b6605c437"
    sha256 cellar: :any_skip_relocation, ventura:        "950250410ffda2307e42e465b0a563b0d4175f83017467df59c580cba41d8c85"
    sha256 cellar: :any_skip_relocation, monterey:       "e7b649410f591aa0d0068ae267e7357db99c86c73fd5e992db0f5512614a07a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4fc9d2c49b65130d04a476d4cd887b1e1033a7870df9805be28aba09be901f0"
    sha256 cellar: :any_skip_relocation, catalina:       "9a1d1160f85f46b3022dc4d978dfafe6b3a02fc97446bc51f8b1ae4580b7c69a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "79c0f6005a2a310f26244eca58d2fb373618921a745704cf868b4ca6190545e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9c5ae5e7ac2f00cf8655ce4b6095e4706bcc36300d36a1c7121ab03d010ea5f"
  end

  uses_from_macos "ruby" => :test

  def install
    args = %W[
      --prefix=#{prefix}
      --info=#{info}
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gtime" => "time" if OS.mac?
  end

  def caveats
    on_macos do
      <<~EOS
        GNU "time" has been installed as "gtime".
        If you need to use it as "time", you can add a "gnubin" directory
        to your PATH from your bashrc like:

            PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    if OS.mac?
      system bin/"gtime", "ruby", "--version"
      system opt_libexec/"gnubin/time", "ruby", "--version"
    else
      system bin/"time", "ruby", "--version"
    end
  end
end
