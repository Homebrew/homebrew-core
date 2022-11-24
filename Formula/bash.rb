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
    version "5.2.12"

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
    sha256 arm64_ventura:  "3a5dd0289fe6acf9153a358c6ca77b1ca7e447fa91f09d76fc9d6f971dc31200"
    sha256 arm64_monterey: "7d73afad09c38eed297ccbdae885fc6c01de1e7f7b00d39fb88532193f582038"
    sha256 arm64_big_sur:  "b84fcc00de20c957408222103c060a7eb6f6ef7cbe4cd6ead95f368289aebda0"
    sha256 ventura:        "fc4818d6a55c5861a7f7aa15f276f542d5f20495198849088a9a81c22666292b"
    sha256 monterey:       "d0cb4298c7ed6f9d634e3687a74c61dd3f955c169f36ef6ce53bd816842f899e"
    sha256 big_sur:        "7ca197c70c3d5986389be319db6afb1530715e89dcd2c1d94329a1bbaf0f5b43"
    sha256 catalina:       "80f0ae13cca14bc3b75ce28f06a59debd5b782b2f2f1af8145bee1ecd3328878"
    sha256 x86_64_linux:   "76e31c1e2aff9068e25736f111d8bf56a5f5ccb07b3591c00cebe8476c239788"
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
