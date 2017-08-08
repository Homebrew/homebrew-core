require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-4.9.0.tgz"
  sha256 "27f72cb1837c5b4c7dd230a5a439d44d948992cbf5de57481bea90b491b9a544"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc3d95026270fa0cea8cca524f92405a3d25f181e665c8852f373f43415073dd" => :sierra
    sha256 "4f6c779f753ab5d31845bc1b22ea7baad3d98667d99a4feaf900017f41e3b423" => :el_capitan
    sha256 "e905fb7cf8dce1ff269631c63ed46cf7d6c781f60e2cc4662ad2ea81f49cbf10" => :yosemite
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
