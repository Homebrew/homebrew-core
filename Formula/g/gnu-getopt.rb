class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.2.tar.xz"
  sha256 "6062a1d89b571a61932e6fc0211f36060c4183568b81ee866cf363bce9f6583e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27be0ec77e47ee54200fa7d252c2c392383c21ad89e5295604f1cce03fe74725"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0edcb62b4098ba54d8a8be8ec75c5d2c21f56a6b9930634b203303fd8f902688"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aafa0b66161a321cecc2b2fadb087fa6a10e80e841cd822c5c207dd55d7aecb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "34d15c3ef2784aa76c27b5e5c6cac0ce6fc6f75ee3606710efb292d506a8ff1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41a4ed96505aea463cd3203d89f789725e55217eb2ff510029d5094bfec665ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e0d3422cef8e9ad8fa43782c0f97371d92c5a0d4e234914228de46c97ad48b7"
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
