class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/bash.git", branch: "master"

  stable do
    url "https://ftp.gnu.org/gnu/bash/bash-5.3.tar.gz"
    mirror "https://ftpmirror.gnu.org/bash/bash-5.3.tar.gz"
    mirror "https://mirrors.kernel.org/gnu/bash/bash-5.3.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.3.tar.gz"
    sha256 "62dd49c44c399ed1b3f7f731e87a782334d834f08e098a35f2c87547d5dbb269"

    # Add new patches using this format:
    #
    # patch_checksum_pairs = %w[
    #   001 <checksum for 5.3.1>
    #   002 <checksum for 5.3.2>
    #   ...
    # ]

    patch_checksum_pairs = %w[]

    patch_checksum_pairs.each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-#{p}"
        mirror "https://ftpmirror.gnu.org/bash/bash-5.3-patches/bash53-#{p}"
        mirror "https://mirrors.kernel.org/gnu/bash/bash-5.3-patches/bash53-#{p}"
        mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.3-patches/bash53-#{p}"
        sha256 checksum
      end
    end
  end

  # We're not using `url :stable` here because we need `url` to be a string
  # when we use it in the `strategy` block.
  livecheck do
    url "https://ftp.gnu.org/gnu/bash/?C=M&O=D"
    regex(/href=.*?bash[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :gnu do |page, regex|
      # Match versions from files
      versions = page.scan(regex)
                     .flatten
                     .uniq
                     .map { |v| Version.new(v) }
                     .sort
      next versions if versions.blank?

      # Assume the last-sorted version is newest
      newest_version = versions.last

      # Simply return the found versions if there isn't a patches directory
      # for the "newest" version
      patches_directory = page.match(%r{href=.*?(bash[._-]v?#{newest_version.major_minor}[._-]patches/?)["' >]}i)
      next versions if patches_directory.blank?

      # Fetch the page for the patches directory
      patches_page = Homebrew::Livecheck::Strategy.page_content(URI.join(@url, patches_directory[1]).to_s)
      next versions if patches_page[:content].blank?

      # Generate additional major.minor.patch versions from the patch files in
      # the directory and add those to the versions array
      patches_page[:content].scan(/href=.*?bash[._-]?v?\d+(?:\.\d+)*[._-]0*(\d+)["' >]/i).each do |match|
        versions << "#{newest_version.major_minor}.#{match[0]}"
      end

      versions
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_sequoia: "e77d408d550e8e9f6669abf16759e35d0b867fe2126121eaa1ff39a94921cd86"
    sha256 arm64_sonoma:  "c447b3c18e307ab9e3e6a5c28ebb09c1e76a51a505ab89948ade6abe8f859bf0"
    sha256 arm64_ventura: "60bd00499cc9a01361143f2ffe15fcc0aa274db1de4b298dedd10fa2533d7e69"
    sha256 sonoma:        "1f0af2a4eb5fddcecdd1d02a841e285dc8302a029f975571fddd4100af79ad67"
    sha256 ventura:       "05a18ddf9001e3fe63f8c972aa24b73df39f6517eb0b5b913ccaf3478c6fa914"
    sha256 arm64_linux:   "925a4ad99d47b25e8dfdd554312acf5f50c0251f7ab003d1d694740f214f8ef1"
    sha256 x86_64_linux:  "0f188fcf662add592183d2b4647ea94bdd1fc001ed9a06920ab4bbc2b62bb9f9"
  end

  # System ncurses lacks functionality
  # https://github.com/Homebrew/homebrew-core/issues/158667
  depends_on "ncurses"

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with macOS defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    # Allow bash to find loadable modules in lib/bash.
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: lib/"bash")}"
    # FIXME: Setting `-rpath` flags don't seem to work on Linux.
    ENV.prepend_path "HOMEBREW_RPATH_PATHS", rpath(target: lib/"bash") if OS.linux?

    system "./configure", "--prefix=#{prefix}", "--with-curses"
    system "make", "install"

    (include/"bash/builtins").install lib/"bash/loadables.h"
    pkgshare.install lib.glob("bash/Makefile*")
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c 'echo -n hello'")
    assert_equal "help is a shell builtin\n", shell_output("#{bin}/bash -c 'enable help; type help'")
  end
end
