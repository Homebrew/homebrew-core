class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.1.tar.xz"
  sha256 "be9ad9a276f4305ab7dd2f5225c8be1ff54352f565ff4dede9628c1aaa7dec57"
  license "GPL-2.0-or-later"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff408edae3f7daaa4a2caa43375edcbb8c3fd76c923a830db7f1a3d1fa09f4b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e7120d4356c61045a30db969e84861cb68d25b09ac79932863dbbfb9da1a903"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d984297f3cb3d49e0d0c1b170f5f7a53c5059e346a6e95dc201a921779d5bfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c2fe6c703e5859385b1cfa3f0e137978af825803d300c6a5edc425f157d8712"
    sha256 cellar: :any_skip_relocation, ventura:       "bd02ee1246a2a24c0af7d488c84c4a4a9bd4d85d592f6ffbd97bb5aacc071604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79fab8a6587ac650c38a219fc757ddcc23f5a747044532e7ead104d13494cc90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65d44421cbaffae2d9c6349af6e0f47484cff7bf9eb985eeaae56e585915c8c8"
  end

  keg_only :shadowed_by_macos, "macOS provides BSD getopt"

  on_linux do
    keg_only "it conflicts with util-linux"
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
