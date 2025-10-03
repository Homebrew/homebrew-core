class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v2.3.0",
      revision: "c93a4fca67cc56585bea1650ba268503ea1883a6"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1f595639e93d5ad5c1cdadfb39a1ce190393a5fdbdcf34dbabdaf6dbe58ade6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1dbec5f7cc97c21b9c41aff384531d3bc065611d9e5f6377afbec4a59010ab5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf056bf44898315518be7c9de6c53de45b3f8bcd83e2aa62ee1ce501239217c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0777dcb10e7d45e2ce5299a58bcf41b99897eb18184f2af532911f2a5f0d0cc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f36d6c89870328a360b3ea74dc65e3a659eb8fe0d40bf4c722189487e17f04a0"
    sha256 cellar: :any_skip_relocation, ventura:       "ae1c6e102f61ef8704807180a323f50f7d1bf0f380ab36977e23d93394e39afb"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    ENV["MAS_DIRTY_INDICATOR"] = ""
    system "Scripts/build", "homebrew/core/mas", "--disable-sandbox"
    bin.install ".build/release/mas"

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
