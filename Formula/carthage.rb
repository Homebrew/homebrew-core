class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      :tag => "0.19.1",
      :revision => "6e3508c881122f64b9e1c7cb768541fd9e99ec3b",
      :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "cee30063b20467da8250cbc42f231a9ccc3d01ae41d1e35c2fd719382fcfb2e4" => :sierra
    sha256 "54c313d83d68db0787761d99744c68de7185536ef9590356d59a626e4653eeac" => :el_capitan
  end

  depends_on :xcode => ["8.2", :build]

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
