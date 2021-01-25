require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-5.6.0.tgz"
  sha256 "e971a797c49b1b2aac8a29ad2b7696b80b7f9da2d302ddc3e1a46b195f4edfd0"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "30d7f0f2e26a504fafc8444b90e243680186c1d10c5ef05e505bb712a3d2d543" => :catalina
    sha256 "b0d541a0e1a22cd63cd3a5ade24de85b9630e1b5d12154063c001d4d21fa81f4" => :mojave
    sha256 "0604c43c2cb219d817eb9129ee501dff2f1d206c8da539eb062c88ba4ed6518d" => :high_sierra
  end

  depends_on "psc-package" => :build
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
