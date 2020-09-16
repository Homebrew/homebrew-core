class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      tag:      "0.35.1",
      revision: "0d324cbd5d3a5b68ec69c84a05ae4a28af95e96f",
      shallow:  false
  license "MIT"
  head "https://github.com/Carthage/Carthage.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "fdaacafff1566fa7b1e42e68e108da69aa7578dc82f4736272dca10283c9cba2" => :catalina
    sha256 "1da29ca0b1d8e79bec5e548f5ab2433890ebc3fc9007f5fdb70d9e3be281dbb7" => :mojave
    sha256 "130fcb9bc06ef8e7f1c5ac9af0d155bd347db039b2cf80fa0fef764b3627ffbf" => :high_sierra
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
