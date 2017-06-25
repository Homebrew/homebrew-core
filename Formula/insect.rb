require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-4.6.0.tgz"
  sha256 "f043cc0da5b0ca77192902af76c2e1b7ba62a003d1a62e97c6296de9db2a1938"

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
