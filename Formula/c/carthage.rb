class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      tag:      "0.40.0",
      revision: "e33e133a5427129b38bfb1ae18d8f56b29a93204"
  license "MIT"
  head "https://github.com/Carthage/Carthage.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "20456de113008e847a0b4abbafcb6e829a537d8aec2f60702114b5978b3839c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1ab671fcc4b39986c412e44002456ec71e5ee23ac9574bcbe653f2c7f1e0c3c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01fa70c2d94efb0b4da3c593708f931e383f99a93e8461fda85804d08564815d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48370b2f3289b9a3b1cfbdc41d0a7507cf12959f766aae5e26f99d03b92777aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "576e684309365ad8e3d16a208267527747dbc97554c3646f78006d49843681f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e5ee2180ddfa8a7e3675a49ad20ab17d4ffe2ce5519653ec7b738e62665ca1a"
    sha256 cellar: :any_skip_relocation, ventura:        "49ec2dc81b3753ea8d83f9b8e4308bf6603f1c8f674df847c7ec86f93d96c0ca"
    sha256 cellar: :any_skip_relocation, monterey:       "4f79410a86ad31251c4993ac3333181245633600ef66906634fbbf64e1c0661d"
  end

  depends_on xcode: ["10.0", :build]
  depends_on :macos

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
    bash_completion.install "Source/Scripts/carthage-bash-completion" => "carthage"
    zsh_completion.install "Source/Scripts/carthage-zsh-completion" => "_carthage"
    fish_completion.install "Source/Scripts/carthage-fish-completion" => "carthage.fish"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system bin/"carthage", "update"
  end
end
