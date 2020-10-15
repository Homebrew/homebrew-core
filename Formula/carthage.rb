class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      tag:      "0.36.0",
      revision: "499c9cf8dafe5979e761397721f319db8bbe5859",
      shallow:  false
  license "MIT"
  head "https://github.com/Carthage/Carthage.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "2ea99e7a332fc6a76a1ca43b087f56534e2c658e7155c0751ffa6407c5e0a528" => :catalina
    sha256 "334d9982e33f71850b1f467a170ab5c7c050f49a3c9f2429d7db4ac1450d975b" => :mojave
    sha256 "962d60c36c3bd904cdd7b1ae0c7199b3de617b84ba7cfee7fdc91e46a413ccb9" => :high_sierra
  end

  depends_on xcode: ["10.0", :build]

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
