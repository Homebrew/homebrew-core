class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.3.tar.xz"
  sha256 "3330d873f0fceb5560b89a7dc14e4f3288bbd880e96903ed9b50ec2b5799e58b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cd2aff2f76e90b315337b38824b6a346dd8531d55f5b9bbb8a69e26e7a61e30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "292d9b482660f78f286ac137ad4c79f9247561da587d9cb577a08c2abc7c53d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f4b12ea4c02121d6574b4c011f0aa636cefa3816ea75d0686081b5e566d7506"
    sha256 cellar: :any_skip_relocation, sonoma:        "e405ec71a589cdacdd6f009e1e46c814f60d026aec8863c17401bbce3aca70cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8caad3359d900c8b40fa47bdc00b6def1b09fa0bff2c4b177991abd59a01b244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2992e719592a0d909c88893f8628e0f00ae76b94ea4a9d9f79a490fe27cf034"
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
