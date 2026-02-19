class Adapterremoval < Formula
  desc "Rapid adapter trimming, identification, and read merging"
  homepage "https://github.com/MikkelSchubert/adapterremoval"
  url "https://github.com/MikkelSchubert/adapterremoval/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "a4433a45b73ead907aede22ed0c7ea6fbc080f6de6ed7bc00f52173dfb309aa1"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d55def0eb8e4d90874c3462c3c2088ee0addd14709835ce600cd277631c94a62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c89e56b55bd143ad31f49b4f21a9a90dd1b2ec589bc93c762b3921a0e5bca28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf4e7d64e4c63c3b1626cc6a4073169bd10af09a31a83c42bb04d3343158198"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d23629123200eacea62c12486cc564549941a3ad868e9a234122b83751afa57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "811e8cb621752ab6dac595d0c716d6d77bfc26254c0a5eb814760c91f2abae94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06fb66c36fde9bd21bd005089ff665eb257a5ed15751414fca394457b27c388c"
  end

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    examples = pkgshare/"examples"
    args = %W[
      --bzip2
      --file1 #{examples}/reads_1.fq
      --file2 #{examples}/reads_2.fq
      --basename #{testpath}/output
    ].join(" ")

    assert_match "Processed a total of 1,000 reads", shell_output("#{bin}/AdapterRemoval #{args} 2>&1")
  end
end
