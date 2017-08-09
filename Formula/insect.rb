require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-4.9.1.tgz"
  sha256 "2ec4f7cb4d1f8cc17d485229379d3c8cb876ba50036c263b9ebfd9fa9ab8cd58"

  bottle do
    cellar :any_skip_relocation
    sha256 "0937ee3986157830d4236f2c8fe7fe5c899987a31655a509ef7c4377c3320f37" => :sierra
    sha256 "2ed00f6cc4f79444514ed856d728070593d2e8155d9fbb6bca1a22d24bc0cbf3" => :el_capitan
    sha256 "7fbaa2aa1c505cf26f5a5b991f539a736474ac5aff1b9fdd22c7481ee44656b2" => :yosemite
  end

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
