require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.2.4.tgz"
  sha256 "00dc5058d1bd450301904203e62c7fe75fb0ec3e54c7ba0b3d958fc1f051678c"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3c786d4b4c0f56a8b591a14f57af037f05ff808b14734749428b7925052d0358" => :big_sur
    sha256 "06c7facb474b12129d9a95e8cda5a2accc77373b9a4718581cab48803ca35edf" => :arm64_big_sur
    sha256 "43b8c98fd8760ea3d1de4c33fe5298d607c8ba31b5068928a9ae25656522ca97" => :catalina
    sha256 "d53aa1593813db052e6495facc8132fd81c2290c94a7c05647b9134a3a3a219a" => :mojave
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
