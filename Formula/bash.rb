class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/bash.git", branch: "master"

  stable do
    url "https://ftp.gnu.org/gnu/bash/bash-5.2.tar.gz"
    mirror "https://ftpmirror.gnu.org/bash/bash-5.2.tar.gz"
    mirror "https://mirrors.kernel.org/gnu/bash/bash-5.2.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.2.tar.gz"
    sha256 "a139c166df7ff4471c5e0733051642ee5556c1cc8a4a78f145583c5c81ab32fb"
    version "5.2.2"

    %w[
      001 f42f2fee923bc2209f406a1892772121c467f44533bedfe00a176139da5d310a
      002 45cc5e1b876550eee96f95bffb36c41b6cb7c07d33f671db5634405cd00fd7b8
    ].each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftp.gnu.org/gnu/bash/bash-5.2-patches/bash52-#{p}"
        mirror "https://ftpmirror.gnu.org/bash/bash-5.2-patches/bash52-#{p}"
        mirror "https://mirrors.kernel.org/gnu/bash/bash-5.2-patches/bash52-#{p}"
        mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.2-patches/bash52-#{p}"
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

  bottle do
    sha256 arm64_monterey: "f144e86255c7b8537e965e1e38622aa89f20bbfbd240dfaaa552406d5c8d5030"
    sha256 arm64_big_sur:  "bcbaef0dbb3758d1d364efe8d166453971166e4f7cb7b5192155a13a780695eb"
    sha256 monterey:       "a844d150df53490c40bd3135dee39490494442e58301233770439849a44731e0"
    sha256 big_sur:        "e86a690fcabda57cebe0d1935b29eb4aff4c60889ee79b6fa821589075f77ff3"
    sha256 catalina:       "29598d781c44882c5bf8d19a1b91b9da747f8e5b5bc89c57626864fb23c602a5"
    sha256 x86_64_linux:   "1d58b8ad0482f5c9ab1211d63693f058279420a119ffba0e8ab0ede795edd219"
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
