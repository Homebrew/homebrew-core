require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-5.3.0.tgz"
  sha256 "770f1c282366bab62fd5cce03416781423d768ee9c88456a11c6159e1e5d776b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3fd6c2de1da3c5194cb1829b176f0ce7ff19305ddf8c9271dc57fc248339651" => :catalina
    sha256 "fb96c43fff8bedc56b885fbd49a924f54bc485460aa428c30bae6b02ee9e422b" => :mojave
    sha256 "46444cc696e42c428815638f1ca6b22dfb6c9f92ee53978dfc0b9d4bd3aa6d6a" => :high_sierra
  end

  depends_on "bower" => :build
  depends_on "pulp" => :build
  depends_on "purescript" => :build
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "120000 ms", shell_output("#{bin}/insect '1 min + 60 s -> ms'").chomp
    assert_equal "299792458 m/s", shell_output("#{bin}/insect speedOfLight").chomp
  end
end
