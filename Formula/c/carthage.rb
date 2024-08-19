class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      tag:      "0.39.1",
      revision: "edf085cc652b9be8270720c21d2ca1b9fb12ff94"
  license "MIT"
  head "https://github.com/Carthage/Carthage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba4ee0fbdfad0f3759def555de4c32802bc56993c97a82d0b515247de138f773"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9adaaa9609a4a96f6cf41ac3f135eeb988ff8e61f13e541f9ab2455a4686ca2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b0c8b903bd8243b9b4ded7cca27fa3dc02868dc6cfea85b7dcd2537fbde1692"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76c60dc59aa5a569816d55e3db88bda26339f481e74f84b3ce562b326264ae73"
    sha256 cellar: :any_skip_relocation, sonoma:         "d05d4f1206685386ecc73d690bcfd968ee868ba0537522a7f3bc2d942b02985d"
    sha256 cellar: :any_skip_relocation, ventura:        "8d3c23086c08866b1431ac914090cee8e8ee610c6f3d3323e2f9d9a5bc31cd01"
    sha256 cellar: :any_skip_relocation, monterey:       "01dd72ad3bb80e3edf44b06632077040915280ace916eb6d5b2c156de1147c6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b58694dad7b77843e008be5b04c0553d74aad7e276558500e454ca13420785e"
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
