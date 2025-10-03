class Npush < Formula
  desc "Logic game similar to Sokoban and Boulder Dash"
  homepage "https://npush.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/npush/npush/0.7/npush-0.7.tgz"
  sha256 "f216d2b3279e8737784f77d4843c9e6f223fa131ce1ebddaf00ad802aba2bcd9"
  license "GPL-2.0-or-later"
  head "https://svn.code.sf.net/p/npush/code/"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "43a5b01bbdaac0c5112a4a7b61e737534968dada416f3ab6fe47b4ad907a1eff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "52bb1bf2c16219188637e18260db7c52d8eead9d02dd9f65bb9d7cfb7adf6520"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58edd27febec742ef46cf8e1b6fca1bf8053a99c953fbd53743a6b12387d924c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee910410e365aa4d509068cb68d14bf871b9a679cfff678db620bbb6603838fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae543262c4b86f3d0babffd21d015739bf5db0838fc7ee604df46cf8e26e3178"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0be6b0d7949e3e6b3322089f84c10c60c15ea41a0a7ebdaa7ff04862c1be103"
    sha256 cellar: :any_skip_relocation, sonoma:         "351248c804fc342573641fe453f90b6e768d8bda8376eaeee18b3a7e169b6bcf"
    sha256 cellar: :any_skip_relocation, ventura:        "019a35f0de52024835407a2fb6d643b9cbf8d9ccc52889f9b40de056a3f73467"
    sha256 cellar: :any_skip_relocation, monterey:       "7f24fc8d2212c912748809e540f129ff5a873d00639c1f2d262d869714746a67"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3b1eb1513919a4120a9c2b6541872b39ef78d9eb618df96e62a1cc6f28d53ff"
    sha256 cellar: :any_skip_relocation, catalina:       "fdb6d7cd95fa85086a4dc01edfb5859fcf65d2932c56d931d716814157f5449e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a2c260b48759fbd27ca1ea3c6bbfe102de40fb4755cd3fc88f03e6a27e2aa236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0f8e3339f262c42ed5d697817a274e292bdd647d5a6410f71d9a9752f044047"
  end

  uses_from_macos "ncurses"

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "Makefile", "$(PROGRAM) $(OBJECTS)", "$(PROGRAM) $(OBJECTS) -lncurses" unless OS.mac?
    system "make"
    pkgshare.install ["npush", "levels"]
    (bin/"npush").write <<~SH
      #!/bin/sh
      cd "#{pkgshare}" && exec ./npush $@
    SH
  end
end
