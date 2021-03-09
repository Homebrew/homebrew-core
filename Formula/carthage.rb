class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      tag:      "0.37.0",
      revision: "0668de43eb5d323d2e816eaab83677f50a8eeb24",
      shallow:  false
  license "MIT"
  head "https://github.com/Carthage/Carthage.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd0c716682b5b094b82a589fb79def4eb696f70a3fd92423923a5cb86c2c79b3"
    sha256 cellar: :any_skip_relocation, big_sur:       "0770b4dd885f3018031c2d27fc090a34027d5856a248f33fa2a415d58da74632"
    sha256 cellar: :any_skip_relocation, catalina:      "8a07c198835cb179d4054313b199ce126e64bb9414eaaa91f55162a4aed63134"
    sha256 cellar: :any_skip_relocation, mojave:        "7fb777ac169aa4cb05683f0f8bfb5b56dbb0b0e8b673df995ef2fb2bbe0d90d2"
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
