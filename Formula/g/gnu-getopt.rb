class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.42/util-linux-2.42.tar.xz"
  sha256 "3452b260bbaa775d6e749ac3bb22111785003fc1f444970025c8da26dfa758e9"
  license "GPL-2.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/"
    regex(/href=.*?util-linux[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      # Match versions from directories
      versions = page.scan(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
                     .flatten
                     .uniq
                     .sort_by { |v| Version.new(v) }
      next versions if versions.blank?

      # Check the highest version, falling back to the second-highest version
      # if no matching versions are found in the version directory (e.g.,
      # upstream has created a version directory using a stable version format
      # but the version directory only contained unstable versions).
      dir_versions = []
      versions[-2..].reverse_each do |version|
        # Fetch the page for the version directory
        dir_page = Homebrew::Livecheck::Strategy.page_content(
          URI.join(@url, "v#{version}/").to_s,
        )
        next versions if dir_page[:content].blank?

        # Identify versions from files in the version directory
        dir_versions = dir_page[:content].scan(regex).flatten
        break unless dir_versions.empty?
      end

      dir_versions.presence || versions
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3cc8fd191a5a86f3a4513da7802a88d6ad099e356eda8638d3be820d7b88966"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6d10dbbad97abd5182b002696df07c3c922d622057c0e3fc3df92dc7d011030"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0653f00fcd1bd3877418161cfc82e66b2dce6ab93befccaa4778e80610ecfc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "73a1eecae19dc3d2974367d98b70a481e96955c9f440a913d78ecc62a6f3546c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f335139ba28c77ff23c03188414769cac5b880b6a4431961afec0f3380c02bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2532f0fe367ea8450cfd00a5a2482d6ec3bd3662fa84ef36fa121153d4c57e7"
  end

  keg_only :shadowed_by_macos, "macOS provides BSD getopt"

  on_linux do
    keg_only "it conflicts with util-linux"
  end

  # Fix macOS builds
  # https://github.com/util-linux/util-linux/pull/4173
  patch do
    url "https://github.com/util-linux/util-linux/commit/d22edc2f100eb8dd83d3515758565cb73b0d2eed.patch?full_index=1"
    sha256 "2fb01154faa3fd8b0fce27eb88049ed9c8f839e706e412399c19c087f7f3b5e1"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-liblastlog2",
                          *std_configure_args

    system "make", "getopt", "misc-utils/getopt.1"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
    doc.install "misc-utils/getopt-example.bash", "misc-utils/getopt-example.tcsh"
  end

  test do
    output = shell_output("#{bin}/getopt --longoptions foo --options ab:c test -b bar --foo baz")
    assert_equal " -b 'bar' --foo -- 'test' 'baz'\n", output
    # Check that getopt is enhanced
    assert_empty shell_output("#{bin}/getopt --test", 4)
  end
end
