class Minibwa < Formula
  desc "Successor of BWA-MEM for short-read alignment"
  homepage "https://github.com/lh3/minibwa"
  url "https://github.com/lh3/minibwa/archive/refs/tags/v0.4.tar.gz"
  sha256 "32b8e3b7e7bf313ef5f5dd0d6f4359a21575fd2b2fcb14652d9181c740fde9b1"
  license all_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20d5d94a87dd0b42c32c6ddcfc4ba594fb8da5a565b2857478708a7086b6e20e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "456a37d8a26602f780e7d0445e7c96eec61d249e0da951a0f997ac9a65ff20db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2993d9063d6b18f7cfd120801c1e449973f9cf4f195c59403627971913b9239f"
    sha256 cellar: :any_skip_relocation, sonoma:        "388d462bf9cb65f226ea967f8adf0f89f6b233622217d948168d74e3418deefa"
    sha256 cellar: :any,                 arm64_linux:   "88275345cca707b86db12b48c9b8de510ec23ae6eb68d62bc62472b222decce5"
    sha256 cellar: :any,                 x86_64_linux:  "7332547a1a76cb6e4f81f50a2228a27f8e6dc616a1922af5ad9e72d2007d997f"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "gpl=0"

    bin.install "minibwa"
    man1.install "minibwa.1"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath

    system bin/"minibwa", "index", "chrM-human.fa.gz", "chrM-human"
    assert_path_exists testpath/"chrM-human.l2b"
    assert_path_exists testpath/"chrM-human.mbw"

    output = shell_output("#{bin}/minibwa map chrM-human chrM-read_1.fa.gz chrM-read_2.fa.gz 2>/dev/null")
    assert_match "@SQ\tSN:chrM", output
  end
end
