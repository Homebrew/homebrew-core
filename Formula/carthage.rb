class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      :tag => "0.26.2",
      :revision => "452f2d5a9917befe722b944360aefd7ae05fc6d5",
      :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "5f6c335afb7a0f7888f8d34908bb39731d9bce269dc1a3d47f37484124e28fbc" => :high_sierra
    sha256 "6985d61d9d71fb0d7f58683240553887ad031c8f1540a09da41a96feaddbb427" => :sierra
  end

  depends_on :xcode => ["9.0", :build]

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
