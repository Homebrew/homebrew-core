class Mirthsync < Formula
  desc "Version control for Mirth Connect and Open Integration Engine config"
  homepage "https://saga-it.com/products/mirthsync"
  url "https://github.com/SagaHealthcareIT/mirthsync/releases/download/3.7.0/mirthsync-3.7.0.tar.gz"
  sha256 "d962b21576d479166185b92c1d88540bd493ba2ab39c0b3b7908d8271dbbc98f"
  license "EPL-1.0"

  depends_on "openjdk"

  deny_network_access!

  def install
    # The upstream bin/mirthsync.sh is deliberately not used: it locates its jar
    # with `readlink -f`, which BSD readlink does not support, falling back to
    # greadlink from coreutils. Under `set -euo pipefail` that aborts on a stock
    # macOS. write_jar_script generates a wrapper that invokes the jar directly.
    libexec.install "lib/mirthsync-#{version}-standalone.jar"
    bin.write_jar_script libexec/"mirthsync-#{version}-standalone.jar", "mirthsync"
  end

  test do
    # The `git` action manages the on-disk repository that channel config is
    # pulled into, and is the part of the tool that works without a running
    # engine. `init` creates a real repository and `status` reads it back, so
    # this exercises actual functionality offline rather than a help flag.
    # Homebrew points HOME at the test directory, and the JVM toolchain drops
    # dotfiles there, so the repository gets its own subdirectory. Initialising
    # in testpath itself reports those dotfiles as untracked.
    repo = testpath/"channels"
    repo.mkpath

    system bin/"mirthsync", "-t", repo, "git", "init"
    assert_path_exists repo/".git"

    assert_match "Working directory is clean",
                 shell_output("#{bin}/mirthsync -t #{repo} git status")
  end
end
