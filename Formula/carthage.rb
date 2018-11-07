class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      :tag      => "0.31.2",
      :revision => "8dea448b9b2814dadb6130dbf8bae4171487dd69",
      :shallow  => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "dcfbfc02d18e352a771997008648aa8dd765188a736733fa45d8af5fea7f81a5" => :mojave
    sha256 "86222951266058640d2794f06f592b7961cf60016184657e8a2269e8f3503a5c" => :high_sierra
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
