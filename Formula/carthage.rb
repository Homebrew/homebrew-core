class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      :tag => "0.31.2",
      :revision => "8dea448b9b2814dadb6130dbf8bae4171487dd69",
      :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "4c86ff31bf54d7ee8dad4e9921d7757c5fc6f4b62ec141e339bcfae667fb23da" => :mojave
    sha256 "99f35655d278ebe1dae617847f77ec5bbae4a8ebbe7c636c7912c53902c0e7a8" => :high_sierra
  end

  depends_on :xcode => ["9.4", :build]

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
