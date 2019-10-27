class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      :tag      => "0.34.0",
      :revision => "25ad8c8ed71afe218aed9a7f7631543ce8adf858",
      :shallow  => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "e3498577798d41c08522e1478e125c2c07fb1c1d1b9aadc447f9d028ec6b3e83" => :catalina
    sha256 "42ec7f8f09fa1701634ba5f8f162778102db7d03a114320296d3b58df8495a6a" => :mojave
    sha256 "948811ce4d294c0deee78142c5606a6277b2436afe31f502fc4681acc62428ee" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]

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
