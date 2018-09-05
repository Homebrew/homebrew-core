require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-5.0.0.tgz"
  sha256 "dcd4030a46a189885c4b1a192eae5e288f49c61436609fc8a0375d5e8ae5ee19"

  bottle do
    cellar :any_skip_relocation
    sha256 "b00b7c4ab9f8edfd724ec2d3b602454669b4c29b0a5b64fed513754a1c6d150a" => :mojave
    sha256 "150801ee2a294e0dc6d875bb1c251084f201934a8e7edb4c8cd703dc0be305af" => :high_sierra
    sha256 "85ec8ee95c28e34ce1fffea11f6d127325e287ca846f9ab3f9f50f15dbfe635c" => :sierra
    sha256 "5f063d4b5c7b31738bc0f7c6789a9a8ea4e91bb2981d4326ea3224690a4d66c5" => :el_capitan
    sha256 "b2e300f21233fd253f3fc51bea665d23750cad12de32c7f1730ca3841c7b1455" => :yosemite
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
