class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      tag:      "0.38.0",
      revision: "9a3d1799ba8f8b9e2d4514cfa53a2cca6064136e"
  license "MIT"
  head "https://github.com/Carthage/Carthage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31e066eb80819a224b4b98b2c5cb9f11989c787e8de7cc0b4c492663fd0e7075"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9be26e66087b149d4d6ff813323fb5fa1ac0ec1a55d3d1a26fc3aafc8f8e8ec"
    sha256 cellar: :any_skip_relocation, monterey:       "17481cd77a643af4799e2c603ae808cd09a6487e73638caab0af8cdeffc2c438"
    sha256 cellar: :any_skip_relocation, big_sur:        "863d4165b65d4a914f0585ca68a2ae15a179d663dbd29e6fd1d0a0ec769b97c3"
    sha256 cellar: :any_skip_relocation, catalina:       "ea1df2bc55049416020811e5c995a28a3d6a0d26ef4bbe67bc9b248a11727e96"
    sha256 cellar: :any_skip_relocation, mojave:         "417d7a04952ad1845e88f8699a508e5fee109f9f903433eb7c4c860738b7843e"
  end

  depends_on xcode: ["10.0", :build]
  depends_on :macos

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
