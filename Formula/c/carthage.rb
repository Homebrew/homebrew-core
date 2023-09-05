class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      tag:      "0.39.0",
      revision: "187a78c62811d3d75a9b1d41bfaeff708936125d"
  license "MIT"
  head "https://github.com/Carthage/Carthage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "207c3a13cdcfd59bfa35bdb4e31be0a3e9e77df81a04dc9a281c1e121b861efb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e47cbb0c43c84cff20f71b02488cafbf05e8844d38d2ec6fcd6625a0c88e998"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a1088a4186a15467696f0130569f0403de04db67347b0de9cf3ec1bc23fb157"
    sha256 cellar: :any_skip_relocation, ventura:        "b7168722ce8a83dab063dc118bf56a44d0a6423aeda1eab6dbad021039ee2fd7"
    sha256 cellar: :any_skip_relocation, monterey:       "cc8b396ad5b820930f6dd9ff60145b423a2fd5840781f34f716880f00ef44371"
    sha256 cellar: :any_skip_relocation, big_sur:        "0df03fabcb07866f6e85c333b6ea8c0ed933d6d3f4697fd1691a2b7eeafed32e"
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
