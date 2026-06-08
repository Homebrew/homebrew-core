class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.42/util-linux-2.42.1.tar.gz"
  sha256 "36d2cfa2ae336732e144c36ceafdf3ed86319f5d7413a49bedb0a773e7833fe3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76720b91a1cf3ccfadee7b30b652e26ab195f1f4bea82ad40ed839153a5d6f82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4539bb3e365e55b838d58308fc845b052bfec32c2d87cbe264369be89475d452"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a11b3dc84d5021bfa1628745df78dc39d8be591282b207ba659fa991290dc12e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c078bafba31e21c42b53b46cf2e5efc8fd9aa28186e52654bc2bf98da6f5a2d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d55884aa1b848218472da8c9bbe505defe0b4ed6ceadf32437aa1e3c62d44bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e4ece1f8685a31eadd656129ab53c1305dd70a226a33a25a56d246d185fb6ab"
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
