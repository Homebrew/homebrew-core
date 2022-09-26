class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  url "https://ftp.gnu.org/gnu/bash/bash-5.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/bash/bash-5.2.tar.gz"
  mirror "https://mirrors.kernel.org/gnu/bash/bash-5.2.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.2.tar.gz"
  sha256 "a139c166df7ff4471c5e0733051642ee5556c1cc8a4a78f145583c5c81ab32fb"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/bash.git", branch: "master"

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

  bottle do
    sha256 arm64_monterey: "1b8834e7c9d1cd89f0cb4514e53ce905f6385c9455fd507298f73b3aa3e55087"
    sha256 arm64_big_sur:  "6954457b4e588e24fb339b407839a9b6c651738175a84adc75bbc525db032ece"
    sha256 monterey:       "2823a6b24dc60b14b692cfc0544753e7d01a5c1f94eb1bdd590f9cb490eb1729"
    sha256 big_sur:        "4f387cc0993f868f31cd76483051a58420f80f57cf4626afc4b881d2a98959bb"
    sha256 catalina:       "85ac02733b659f4a7884395ed2cfd7dbdf59999a0d8a434a0c1a75085009ce2a"
    sha256 x86_64_linux:   "41849dc2ac9388255aaed32879cb32f977b9730220981eeca32bffca0b3bfb5f"
  end

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with macOS defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo -n hello\"")
  end
end
