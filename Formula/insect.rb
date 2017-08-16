require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-5.0.0.tgz"
  sha256 "dcd4030a46a189885c4b1a192eae5e288f49c61436609fc8a0375d5e8ae5ee19"

  bottle do
    cellar :any_skip_relocation
    sha256 "40cf66124fe03296789ac34ef8e65161364af736c991392376b0c2fe99b6d778" => :sierra
    sha256 "5e47b94c7a5155fed0930fa35ccabd6afebb76e7d6ef2b44ce92718942027261" => :el_capitan
    sha256 "b746305cde4e22ea981b8cbedc4cc7ff375247128c95fd55be7c4acbd785029c" => :yosemite
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
