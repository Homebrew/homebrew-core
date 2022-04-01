class Npush < Formula
  desc "Logic game similar to Sokoban and Boulder Dash"
  homepage "https://npush.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/npush/npush/0.7/npush-0.7.tgz"
  sha256 "f216d2b3279e8737784f77d4843c9e6f223fa131ce1ebddaf00ad802aba2bcd9"
  license "GPL-2.0"
  head "https://svn.code.sf.net/p/npush/code/"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae543262c4b86f3d0babffd21d015739bf5db0838fc7ee604df46cf8e26e3178"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0be6b0d7949e3e6b3322089f84c10c60c15ea41a0a7ebdaa7ff04862c1be103"
    sha256 cellar: :any_skip_relocation, monterey:       "7f24fc8d2212c912748809e540f129ff5a873d00639c1f2d262d869714746a67"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3b1eb1513919a4120a9c2b6541872b39ef78d9eb618df96e62a1cc6f28d53ff"
    sha256 cellar: :any_skip_relocation, catalina:       "fdb6d7cd95fa85086a4dc01edfb5859fcf65d2932c56d931d716814157f5449e"
    sha256 cellar: :any_skip_relocation, mojave:         "fb3618689797a95b8296a7b37f3c8f2e9cb29fdcbd9b2fc9ac9d585e46d6eab3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c3d40f8709487c01053f5ea09e35c047ae6bfede34d21e97703d38c9985d67b0"
    sha256 cellar: :any_skip_relocation, sierra:         "ce2f958ef8d766791137266e74b7c2cd0843755d080ecbbd6a7074bc7d035c19"
    sha256 cellar: :any_skip_relocation, el_capitan:     "c37e743784c68e9c1bb1527d4c6161a5653831de44b3203be8c1cb07d9eeb7c2"
    sha256 cellar: :any_skip_relocation, yosemite:       "d334de125247efff9ce8031cedbb240a493b355a66cae5e6687cefb414d69ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0f8e3339f262c42ed5d697817a274e292bdd647d5a6410f71d9a9752f044047"
  end

  uses_from_macos "ncurses"

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "Makefile", "$(PROGRAM) $(OBJECTS)", "$(PROGRAM) $(OBJECTS) -lncurses" unless OS.mac?
    system "make"
    pkgshare.install ["npush", "levels"]
    (bin/"npush").write <<~EOS
      #!/bin/sh
      cd "#{pkgshare}" && exec ./npush $@
    EOS
  end
end
