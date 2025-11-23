class Mas < Formula
  desc "Mac App Store command-line interface"
  homepage "https://github.com/mas-cli/mas"
  url "https://github.com/mas-cli/mas.git",
      tag:      "v3.1.0",
      revision: "d51db64fad628ce45599bede5d8319407f193d81"
  license "MIT"
  head "https://github.com/mas-cli/mas.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfcf5d0b9331ab6e44e67a3dde0311a51fccaf0027ac1c096e8a3a23e3890622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa364d0a297d4320ff5e7bd502819bdddddc442023218a4f20529d9e60e21cbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de5ec30964de418df057cfa4b49210531db5b0e44c3d687ce3491b7a5e090c37"
    sha256 cellar: :any_skip_relocation, sonoma:        "778ddc524eee626da7efbf8fabfc0ae6836645b67059939a725765f2a8a1a434"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    ENV["MAS_DIRTY_INDICATOR"] = ""
    system "Scripts/build", "homebrew/core/mas", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/mas"
    system "swift", "package", "--disable-sandbox", "generate-manual"
    man1.install ".build/plugins/GenerateManual/outputs/mas/mas.1"
    bash_completion.install "contrib/completion/mas-completion.bash" => "mas"
    fish_completion.install "contrib/completion/mas.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/mas version").chomp
    assert_includes shell_output("#{bin}/mas info 497799835"), "Xcode"
  end
end
