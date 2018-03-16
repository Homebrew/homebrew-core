class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      :tag => "0.28.0",
      :revision => "19e584623e548de68f424ea5c5dc4c081d750112",
      :shallow => false
  head "https://github.com/Carthage/Carthage.git", :shallow => false

  bottle do
    cellar :any
    sha256 "447681514adebd562ac6dba28380e177b59f273059ace07d0ad3f9bdde799bbd" => :high_sierra
    sha256 "9eb176f9fcbd997ae7d692362d526cafedd87bc506de92db7db2f6dd9bdf9775" => :sierra
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
