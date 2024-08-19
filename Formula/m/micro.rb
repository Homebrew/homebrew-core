class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro.git",
      tag:      "v2.0.13",
      revision: "68d88b571de6dca9fb8f03e2a3caafa2287c38d4"
  license "MIT"
  head "https://github.com/zyedidia/micro.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8090777c1195b1a6b02310097fe38b49f465ee288f74afc7412b5e59b9f154f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9477ebf70e505a818742f44e12a70fda5befcb658fd87b57e1b0dd338df5bd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fec4fd7a536df52cbd85b482f465fa1194ee6edba0ba8b4ed8bf5e3af4deab4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2c1b9da068a6ad3ff89f01e26b93549d7d64b7db32c3a426d2a2213711d2e75"
    sha256 cellar: :any_skip_relocation, ventura:        "bb96a61bfa285c4909dd328c513a8e782a3eed5cdedf3442e847dbffb066219e"
    sha256 cellar: :any_skip_relocation, monterey:       "af0dd24f7dddf4d70a945b1be2853d8cb41975b02486974426780e24065d8bbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a19f6dbad44db8af101b7b6e7f0b465961f8b6744262e0d66ab5bf00629dee59"
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
