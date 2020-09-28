require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-5.5.0.tgz"
  sha256 "88cf5db4b79fd58d52fcfbda68cd17361c99c1d6a1b656e6d932a47fc8889027"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1a7bbd56f97d661e4e236e8375db1614659cf2a35d2112feab11c258d437b054" => :catalina
    sha256 "8ba4c9bce3fa2fa0dc6546910d0ed7afff432f2e7938e63638c6494a197bba23" => :mojave
    sha256 "d0efc8426a611811210f093f7a91671fd3f741619709ca88f04274ce7f8e9c06" => :high_sierra
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
