class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      :tag => "0.26.0",
      :revision => "1cf248d5ea508749be63ae82392f0b32cd179ff3",
      :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "7bf28c3e7f5869fa4795e48802fd5e57d101467767b0e80f3058c25710beb03c" => :high_sierra
    sha256 "4fcaee6be5c136da7904c0c319623d0a21d48630ec36d20bf42bae4266ae39b2" => :sierra
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
