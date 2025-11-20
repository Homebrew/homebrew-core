class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      tag:      "v2.0.14",
      revision: "04c577049ca898f097cd6a2dae69af0b4d4493e1"
  license "MIT"
  head "https://github.com/zyedidia/micro.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e391c71bd5666b01c1362cf89d9067077c8958ef3bb3fa26ad71c416b739ce9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "73b14a51ea6138cc9dd4892ac69c1f1621824315c7d2e40ee8867b39db8e1bcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c51f1a11fe4f9fa233ce8459e4fc4b0105c9d24f3f0855e50979d35b2a3de0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1875a20cb2321214d7cf88b3f98c045d6d1e303b7889544b04a0c7b234217e4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf26b77b02d965b093ca4dc67710792d8009ede8634a523dbadac3d340b19a6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f72a6f86533a0065f6e29964b5f6b88d20528b6cec86411a4cb22fe2aa5a2e89"
    sha256 cellar: :any_skip_relocation, ventura:        "bf44beaab0f1a685d5bca117b0aa86ce0bfe4edcbd44c12dbcb493fdb5b27c29"
    sha256 cellar: :any_skip_relocation, monterey:       "05906fffbde05ec39f1f1d2b05c2f73fa43c4f5c5b7bd233fea1a9292a8c9265"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "70725916fc322eaca076503f83e6782ddaebf10794841b3220dcaabbc7f6bd4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbb3b288471091c23205f85c2dd964c4c855fb60165f075f5eca4f23ec998a08"
  end

  depends_on "go" => :build

  def install
    system "make", "build-tags"
    bin.install "micro"
    man1.install "assets/packaging/micro.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
