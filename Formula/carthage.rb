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
    sha256 "5b2afa3e9f600f519f7dd5069b416fbbdbe03b0046c145965b974ff73162f5ac" => :mojave
    sha256 "ff3b1cf943d4ca2a89531f62c03878a6d56ed06bad0a627615b57b9ed2ab9650" => :high_sierra
  end

  depends_on :xcode => ["9.4", :build]

  def install
    match = "XCODEFLAGS=-workspace 'Carthage.xcworkspace' -scheme 'carthage' DSTROOT=$(CARTHAGE_TEMPORARY_FOLDER)"
    inreplace "Makefile" do |s|
      s.sub!(match, match + " OTHER_LDFLAGS=-Wl,-headerpad_max_install_names")
    end
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
