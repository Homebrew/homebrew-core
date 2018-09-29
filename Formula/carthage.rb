class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      :tag => "0.31.0",
      :revision => "04994e9e844d53220d8796a648a7dad12a5808c9",
      :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "dc0027940db2a5017b96228c1b9903a460cafac07e8fa47684805ceb784532cb" => :high_sierra
    sha256 "1d7ffb4d63ad048712d6b81f7e26fa4c5613d5dd6d34c3e5c46a086854d3a59e" => :sierra
  end

  depends_on :xcode => ["9.4", :build]

  patch do
    url "https://gist.githubusercontent.com/jdhealy/8db93b4e3791fa3715554b01e55d366d/raw/88d2913bd9cc0408a11a75715c593789ebcfb068/patch.diff"
    sha256 "47a9b2c48373d4eacc54d684f0d55597b07464e1d2bcbde3384cbc61467a96e4"
  end

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
