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
    sha256 "003e2a5e62cee61b92252eaa82c086cdf70137f4bbaf081f8112f1d9ed7b780b" => :catalina
    sha256 "8beb06f0b8e5a2f576dd4b13cf70d71c6009ffd8530ea7e9a0690872c1197189" => :mojave
    sha256 "56137febe41808c75c8a8827f50c67c03ee472e3e8ab7c53554e262c8750fec2" => :high_sierra
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
