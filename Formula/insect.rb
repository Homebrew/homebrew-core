require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-5.2.0.tgz"
  sha256 "858c8b9ca7172946315840103117b719f7325ce172d63c492538900ce17725a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ae55092fc7332860b7910a517d171acba1df9c9fcb4b068f57548f1b08a0763" => :mojave
    sha256 "19db2952dd8cd7309f8e3c0d8f249c5cdfbb9d3310726ed9b3fa347f2f4dbe4d" => :high_sierra
    sha256 "f5f0af7ff660e022bdccdfd0ecf1a33b0b06a7a2c64286570042f4f840e1466c" => :sierra
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
