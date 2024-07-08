class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.6.20.tar.gz"
  sha256 "943afe708d4097c38ff2011805d51e6a1f1451c991c6fde409387c8068a359a8"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22ff33fbf71566b64ec3331175d1f327f0b10133e676e2bcbd8179522896bd9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60d0d0797bee8af7260aecddf3385cb0e612ff980c3dd9f41c5a69840016e220"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1ca066572e0c25a856db01ae48dc2e32b724651d46f3e869e039362af9eb293"
    sha256 cellar: :any_skip_relocation, sonoma:         "df1a9f249620c61bed71863083769d7b356732d3aacdc5a02412d37a63732c77"
    sha256 cellar: :any_skip_relocation, ventura:        "6ea38de83854d62e4fcc55e82d03d452fe3c465dd6ac585c97df9794f80bcd9d"
    sha256 cellar: :any_skip_relocation, monterey:       "41c4eeff46b11e130b4700d48774f4ea148464562043ade8b3f717f3b9c467b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c8d303da8550bcd170b93469c7c855e58fcc488dc4291af339ff2c7b98e6139"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
