class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/bash.git", branch: "master"

  stable do
    url "https://ftpmirror.gnu.org/gnu/bash/bash-5.3.tar.gz"
    mirror "https://ftp.gnu.org/gnu/bash/bash-5.3.tar.gz"
    mirror "https://mirrors.kernel.org/gnu/bash/bash-5.3.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.3.tar.gz"
    sha256 "0d5cd86965f869a26cf64f4b71be7b96f90a3ba8b3d74e27e8e9d9d5550f31ba"
    version "5.3.3"

    # Add new patches using this format:
    #
    # patch_checksum_pairs = %w[
    #   001 <checksum for 5.3.1>
    #   002 <checksum for 5.3.2>
    #   ...
    # ]

    patch_checksum_pairs = %w[
      001 1f608434364af86b9b45c8b0ea3fb3b165fb830d27697e6cdfc7ac17dee3287f
      002 e385548a00130765ec7938a56fbdca52447ab41fabc95a25f19ade527e282001
      003 f245d9c7dc3f5a20d84b53d249334747940936f09dc97e1dcb89fc3ab37d60ed
    ]

    patch_checksum_pairs.each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftpmirror.gnu.org/gnu/bash/bash-5.3-patches/bash53-#{p}"
        mirror "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-#{p}"
        mirror "https://mirrors.kernel.org/gnu/bash/bash-5.3-patches/bash53-#{p}"
        mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.3-patches/bash53-#{p}"
        sha256 checksum
      end
    end
  end

  # We're not using `url :stable` here because we need `url` to be a string
  # when we use it in the `strategy` block.
  livecheck do
    url "https://ftpmirror.gnu.org/gnu/bash/?C=M&O=D"
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

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "c334ace988880c652a96a7be9e9c4ff03ba59db64ce66d3b0aefa8fb5e0780a8"
    sha256 arm64_sequoia: "9b4b897e4fe4df3ffdfcd47265ca1c5c563265d9de490b6ef8deb75580ad4ee2"
    sha256 arm64_sonoma:  "82f6c2822bd49dae8d15be45fc347ebc91100de1fdad421b1360d4caf5526df3"
    sha256 arm64_ventura: "721bdf14667a59cb7a24d4d476e0228649483513a2d3c9e93908564380915032"
    sha256 sonoma:        "94ef4a156e8cf4be1ae0a056aa988324d89cea55c2ec8f29ec9646a9df258441"
    sha256 ventura:       "7d259d44cfcbc36bb9c7c21fa8a08138868b39ce36dd963f853f9d50d9202145"
    sha256 arm64_linux:   "08e2e633ceb91d97c90205197d521607a3bcc3a491a18ae16d0fd3f1acf80d31"
    sha256 x86_64_linux:  "5d178cd059067f0e76c91ad7515304576052dd8727d5a7c50fc7b9caa0b5bc32"
  end

  # System ncurses lacks functionality
  # https://github.com/Homebrew/homebrew-core/issues/158667
  depends_on "ncurses"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  def bash_loadables_path
    [
      "#{HOMEBREW_PREFIX}/lib/bash",
      # Stock Bash paths; keep them for backwards compatibility.
      "/usr/local/lib/bash",
      "/usr/lib/bash",
      "/opt/local/lib/bash",
      "/usr/pkg/lib/bash",
      "/opt/pkg/lib/bash",
      ".",
    ].uniq.join(":")
  end

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with macOS defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    ENV.append_to_cflags "-DDEFAULT_LOADABLE_BUILTINS_PATH='\"#{bash_loadables_path}\"'"

    # Avoid crashes on macOS 15.0-15.4.
    ENV["bash_cv_func_strchrnul_works"] = "no" if OS.mac? && MacOS.version <= :sequoia

    system "./configure", "--prefix=#{prefix}", "--with-curses", "--with-installed-readline"
    system "make", "install"

    (include/"bash/builtins").install lib/"bash/loadables.h"
    pkgshare.install lib.glob("bash/Makefile*")
  end

  def caveats
    "DEFAULT_LOADABLE_BUILTINS_PATH: #{bash_loadables_path}"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c 'echo -n hello'")
    # If the following assertion breaks, then it's likely the configuration of `DEFAULT_LOADABLE_BUILTINS_PATH`
    # is broken. Changing the test below will probably hide that breakage.
    assert_equal "csv is a shell builtin\n", shell_output("#{bin}/bash -c 'enable csv; type csv'")

    return if OS.linux? || MacOS.version > :sequoia

    refute_match "U _strchrnul", shell_output("nm #{bin}/bash")
  end
end
