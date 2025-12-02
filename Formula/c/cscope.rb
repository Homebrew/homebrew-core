class Cscope < Formula
  desc "Tool for browsing source code"
  homepage "https://cscope.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cscope/cscope/v15.9/cscope-15.9.tar.gz"
  sha256 "c5505ae075a871a9cd8d9801859b0ff1c09782075df281c72c23e72115d9f159"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/cscope[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "a0a30f47c29cb9473180bfe1c3670ceff999e1cd694babbe88d90e012cca0827"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "690ea8542348fc155da1a174f6e98cf08d81be181a222853a504124c9071c08b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45fbc22efa33e380eeca6976ad47869871115e9be506b16dfce771783ccd7c0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "955599d1da5c49055ac99ef74278c40fa33079472e106115a5b3d754758167e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b85e2ad5e9ddcdb57a2cca430520e64f70cefd2b182bae70c216360e72757611"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "149cb1ebe576bca4c8c928ed98005054e9ac2b8822c80ce9582d500453bce0ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "151c5fc8f429b052dedb87188017857da6fd4966f47bb1de1044a77adc2bb9ab"
    sha256 cellar: :any_skip_relocation, ventura:        "2de1fac38c80a9b6643ebaaf7990928e7ea2764c435489d8fda616e661620d03"
    sha256 cellar: :any_skip_relocation, monterey:       "0baacd94730059e4a03e8980f1332ca38ed48f98dc70950103a71f4435347f2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "41553bf0bbc2ce6e41712381fcbc2d86eca0dd4618d138ca70037df8a1bf4e01"
    sha256 cellar: :any_skip_relocation, catalina:       "212b5f945f2a2eae2d07893bb08c490098f4f3e58ec8865499bec550882de29e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "57d5c5b934b8aa1bca7f20239d413f6522e192b107cd8f0ecabb75d2f3b390fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aed0460f7dc9a9355d4fb019760284424d56012224f12df098c8fe9912c904c2"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      void func()
      {
        printf("Hello World!");
      }

      int main()
      {
        func();
        return 0;
      }
    C
    (testpath/"cscope.files").write "./test.c\n"
    system bin/"cscope", "-b", "-k"
    assert_match(/test\.c.*func/, shell_output("#{bin}/cscope -L1func"))
  end
end
