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
    version "5.2.37"

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
      016 155853bc5bd10e40a9bea369fb6f50a203a7d0358e9e32321be0d9fa21585915
      017 1c48cecbc9b7b4217990580203b7e1de19c4979d0bd2c0e310167df748df2c89
      018 4641dd49dd923b454dd0a346277907090410f5d60a29a2de3b82c98e49aaaa80
      019 325c26860ad4bba8558356c4ab914ac57e7b415dac6f5aae86b9b05ccb7ed282
      020 b6fc252aeb95ce67c9b017d29d81e8a5e285db4bf20d4ec8cdca35892be5c01d
      021 8334b88117ad047598f23581aeb0c66c0248cdd77abc3b4e259133aa307650cd
      022 78b5230a49594ec30811e72dcd0f56d1089710ec7828621022d08507aa57e470
      023 af905502e2106c8510ba2085aa2b56e64830fc0fdf6ee67ebb459ac11696dcd3
      024 971534490117eb05d97d7fd81f5f9d8daf927b4d581231844ffae485651b02c3
      025 5138f487e7cf71a6323dc81d22419906f1535b89835cc2ff68847e1a35613075
      026 96ee1f549aa0b530521e36bdc0ba7661602cfaee409f7023cac744dd42852eac
      027 e12a890a2e4f0d9c6ec1ce65b73da4fe116c8e4209bac8ac9dc4cd96f486ab39
      028 6042780ba2893daca4a3f0f9b65728592cd7bb6d4cebe073855a6aad4d63aac1
      029 125cacb37e625471924b3ee06c54cb1bf21b3b7fe0e569d24a681b0ec4a29987
      030 c3ff73230e123acdb5ac216921a386df8f74340459533d776d02811a1f76698f
      031 c2d1b7be2df771126105020af7fafa00fffd4deff4a4e45d60fc6a235bcba795
      032 7b9c77daeca93ff711781d7537234166e83ed9835ce1ee7dcd5742319c372a16
      033 013ec6cc10ad98060a7c34ed5c11187bcc5bf4510f32de0d545db89a9a52a2e2
      034 899fbb3b338048fe52a9c8252bf65ef1194cdff4f7a3fb3316f5f2396143232e
      035 821a0a47fa692bb0a39482728b1b396bf951e2912768fea6f3026c813c1913e5
      036 15c93f4936a5e5b88301f3ede767a23d3dd19635af2f3a91fb4cc0e560ca9057
      037 8a2c1c3b5125d9ae5b47882f7d2ddf9648805f8c67c13aa5ea7efeac475cda94
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
    assert_equal "csv is a shell builtin\n", shell_output("#{bin}/bash -c 'enable csv; type csv'")
  end
end
