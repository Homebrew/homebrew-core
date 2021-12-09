class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://www.vervest.org/htp/archive/c/htpdate-1.2.3.tar.xz"
  sha256 "6b4e3fbf93d552a3a20f30a3906bf0caac05d9626bd508220744010fe9dd53f0"

  livecheck do
    url "https://www.vervest.org/htp/?download"
    regex(/href=.*?htpdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81c655e005bf2af4bd331e785fb9ffaceffa0c9b3162f8a3cbe97d67c187f072"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47ae85d154cd8ed33adefe6703738680842e47a4e881ac61717e663e316074b8"
    sha256 cellar: :any_skip_relocation, monterey:       "f95d60bb2de0850225a56c239dd231ffe842641cbb606097868e0806924266ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b916f25708092eb35e3b4154932c593bf0bb13444f50c0f147494596705574a"
    sha256 cellar: :any_skip_relocation, catalina:       "f8467bdd46f2b8755dfa6b93c0c915bf0ab50cf46cca136a85fdc9a660ea274e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fae6bf9320dd8e15bf17edb55f5d7cc7c282a18fe1df7390bc8b09eded4645b7"
  end

  depends_on macos: :high_sierra # needs <sys/timex.h>

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{bin}/htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end
