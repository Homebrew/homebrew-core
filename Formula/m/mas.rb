class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v1.9.0",
      revision: "01ed1d4e9070811792e8371a4a4dcf27a9512839"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11e8997a99ca12d9b1139289ba9bc3b7f7bcda9f91606ea7584c1706492cdd38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b159cd4bd45185064191007169c901d5d0e0158c459d8df0fad8a32c7e4f41c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6699cf3c85b6efa23c2f556a2401d022f5c15c356419ca51a7f082bd1d4cd485"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb51318ed111a5a2fbf605995c5d5a0521a9ab6468b2d40845648eb766025d92"
    sha256 cellar: :any_skip_relocation, ventura:       "77d0438a4052e7dd9ac1b4eaa66070134d0247c271c8017776a7b61fc35ff2ca"
  end

  depends_on xcode: ["14.2", :build]
  depends_on :macos

  def install
    system "script/build", "--disable-sandbox"
    bin.install ".build/release/mas"

    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
