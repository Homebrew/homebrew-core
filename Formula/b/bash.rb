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
    version "5.2.15"

    %w[
      001 f42f2fee923bc2209f406a1892772121c467f44533bedfe00a176139da5d310a
      002 45cc5e1b876550eee96f95bffb36c41b6cb7c07d33f671db5634405cd00fd7b8
      003 6a090cdbd334306fceacd0e4a1b9e0b0678efdbbdedbd1f5842035990c8abaff
      004 38827724bba908cf5721bd8d4e595d80f02c05c35f3dd7dbc4cd3c5678a42512
      005 ece0eb544368b3b4359fb8464caa9d89c7a6743c8ed070be1c7d599c3675d357
      006 d1e0566a257d149a0d99d450ce2885123f9995e9c01d0a5ef6df7044a72a468c
      007 2500a3fc21cb08133f06648a017cebfa27f30ea19c8cbe8dfefdf16227cfd490
      008 6b4bd92fd0099d1bab436b941875e99e0cb3c320997587182d6267af1844b1e8
      009 f95a817882eaeb0cb78bce82859a86bbb297a308ced730ebe449cd504211d3cd
      010 c7705e029f752507310ecd7270aef437e8043a9959e4d0c6065a82517996c1cd
      011 831b5f25bf3e88625f3ab315043be7498907c551f86041fa3b914123d79eb6f4
      012 2fb107ce1fb8e93f36997c8b0b2743fc1ca98a454c7cc5a3fcabec533f67d42c
      013 094b4fd81bc488a26febba5d799689b64d52a5505b63e8ee854f48d356bc7ce6
      014 3ef9246f2906ef1e487a0a3f4c647ae1c289cbd8459caa7db5ce118ef136e624
      015 ef73905169db67399a728e238a9413e0d689462cb9b72ab17a05dba51221358a
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
    sha256 arm64_sonoma:   "d5ff320435e9372b422dc299bde61a54c7f36b21aa001d26fbd4d34361060f43"
    sha256 arm64_ventura:  "f3a42b9282e6779504034485634a2f3e6e3bddfc70b9990e09e66e3c8c926b7d"
    sha256 arm64_monterey: "5e7e3e3387fc60e907683b437ac6e64879e117a3c5c1421fe6e6257f6aaa3c69"
    sha256 arm64_big_sur:  "d19858831275271cc8aa9a1a28de6223faa44c6ebbc88e83898fd559de5b627e"
    sha256 sonoma:         "9ff0c31889d726faa460e1193992b306c2af4119c5b48574ef4ad39b179636c8"
    sha256 ventura:        "fd01a9dbdc56f6313a725cb345a3b991cfdaa9e1a91b08fd9791a0e695b55723"
    sha256 monterey:       "05a5f9435c9e9ffe8377b03e0ca6b27bbb32cc01aff47dd1692cd8d7e735ab3a"
    sha256 big_sur:        "680dd3b37e17cc4fa1af6dd8c51c774dd0c9aa3e594e96527020845516b1ea77"
    sha256 x86_64_linux:   "6185e7cdba0e671528c9f38b104c4af58a670240672f83537bfc95983476fbc2"
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
