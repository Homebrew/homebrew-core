class Hfsutils < Formula
  desc "Tools for reading and writing Macintosh volumes"
  homepage "https://www.mars.org/home/rob/proj/hfs/"
  url "https://ftp.osuosl.org/pub/clfs/conglomeration/hfsutils/hfsutils-3.2.6.tar.gz"
  mirror "https://fossies.org/linux/misc/old/hfsutils-3.2.6.tar.gz"
  sha256 "bc9d22d6d252b920ec9cdf18e00b7655a6189b3f34f42e58d5bb152957289840"
  license "GPL-2.0-or-later"

  livecheck do
    url "ftp://ftp.mars.org/pub/hfs/"
    regex(/hfsutils[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3d8d4be93e186cb4e5f1aee2e128bbe94f68341e463b3fa86ea5cf15c30d0603"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2a486e1123355f24eb17dd33821edbfa4c9f7f505ffa9009f8380a0000b4f45f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d2cb41e60bac6d99365b3efc77078c76f6d13c92d9cc5413065db01f739a8c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8245a9a524d4f34c9a005a09a56f6d190ec20583c43fb8c1317fbc13827fc37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d74c98e3e180254629b1dbcf8898a6de9167d28feaabed35b76d3aebcf84b5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "107acc6f2b286756c2d74d4973eb367071d53ed4271aabfcdde504818f2458ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0e5cc460ae549e009fa87ccb3da5d0c369cf36f702219d126b395c144f07bb8"
    sha256 cellar: :any_skip_relocation, ventura:        "cf4d77dfdb1ede0dc9b5cbdeba835284926b201d5f8afc7830d7fb59bb68b39f"
    sha256 cellar: :any_skip_relocation, monterey:       "6ae0944174c9dd94812396503c259d281061fa2706f610b03d538d9e502b17c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "133b4b04a161486e76ca06ed4e78086a83ce7ed238b10b879f78a93d66d9dc68"
    sha256 cellar: :any_skip_relocation, catalina:       "5a0e074c5fdcfb43508e049941dd5d7384a7f4843c8d0fe3df325880a45823fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "884c03ae82783f8f238c85d784850ca15dfbf5a92c8d0948412551e850051111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec4614155fc7221a5410f47eac547e8c6c906bfa9965acfc03433fee57a997c9"
  end

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

    # hpwd.c:55:7: error: call to undeclared library function 'strcmp' with type 'int (const char *, const char *)';
    # ISO C99 and later do not support implicit function declarations
    # Notified the author via email on 2023-01-05
    inreplace "hpwd.c", "# include <stdio.h>\n", "# include <stdio.h>\n# include <string.h>\n"

    system "./configure", "--mandir=#{man}", *std_configure_args
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    system "dd", "if=/dev/zero", "of=disk.hfs", "bs=1k", "count=800"
    system bin/"hformat", "-l", "Test Disk", "disk.hfs"
    output = shell_output("#{bin}/hmount disk.hfs")
    assert_match(/^Volume name is "Test Disk"$/, output)
    assert_match(/^Volume has 803840 bytes free$/, output)
  end
end
