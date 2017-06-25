require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-4.6.0.tgz"
  sha256 "f043cc0da5b0ca77192902af76c2e1b7ba62a003d1a62e97c6296de9db2a1938"

  bottle do
    cellar :any_skip_relocation
    sha256 "d46b57f2dbd454ecb340e9a0266f079e812a397fbf9a3753622ba26e5c7f1f84" => :sierra
    sha256 "92c3083d92ae55201cd7b2e2787ba780a759a67ba9f132fe0f0fb59d46e515a8" => :el_capitan
    sha256 "cb53d9e023b9ac9d2c2bd415c244a1fcdfe5e65a0763445eb5f841474edd24a1" => :yosemite
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
