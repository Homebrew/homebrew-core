class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/util-linux/util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.40/util-linux-2.40.4.tar.xz"
  sha256 "5c1daf733b04e9859afdc3bd87cc481180ee0f88b5c0946b16fdec931975fb79"
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

      # Assume the last-sorted version is newest
      newest_version = versions.last

      # Fetch the page for the newest version directory
      dir_page = Homebrew::Livecheck::Strategy.page_content(
        URI.join(@url, "v#{newest_version}/").to_s,
      )
      next versions if dir_page[:content].blank?

      # Identify versions from files in the version directory
      dir_versions = dir_page[:content].scan(regex).flatten

      dir_versions || versions
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24e3eb7e6c01fff592fbd7164de2d7d50066c1bceaf603be4e7a5ceb5ce50d7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77bc7ffe11cdcb42f8a881cd5b94387c3256151368838c6aea183aa7d49b4f88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec0572e61250be617ecb43f3a510367346b892513c59fe747e5112b18c80605a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a82fd4ac44d93d2ba9ea942bd3508c513d88294bf4fd30dcdf7c9cc506985d7e"
    sha256 cellar: :any_skip_relocation, ventura:       "74b397b3555d9421d60813e226c75b9ee7d09f3e8a3f78271fe4dd3c0b8fb18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d1d16f2d1a15fb653999ee2a54691ff400cf87916ec81cae64f28f9f24b48da"
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
