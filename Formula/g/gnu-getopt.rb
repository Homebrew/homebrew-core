class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.tar.xz"
  sha256 "81ee93b3cfdfeb7d7c4090cedeba1d7bbce9141fd0b501b686b3fe475ddca4c6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56589a88d65309ca6eb5f8110dba58a592bb39dfca2b01ec3e710d1515301a9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f66eab32c181a9f58ac40434ad4fdb7908e2f9e8ef0247f2076105a1811d2395"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4d0fbdb714ad12cf070d38a590066c9b0b25be32025f3d96672dd7912ab293b"
    sha256 cellar: :any_skip_relocation, sonoma:        "410a045158138d1b15ec926fd02c04132562f26b848a6950c90ee7204918de83"
    sha256 cellar: :any_skip_relocation, ventura:       "31bf079de0d0829cba00e616fc79ddb787a3fcfc559024905c47512a78871871"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b0019e2baad11e4f81fd6f94381a2bc78f404111188ef7d9c8ec4ee7dee6688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87f5c0068cb0fa80cf8b814cfb3ff8501e4ff1fa65eae15a20328bd782e76434"
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
