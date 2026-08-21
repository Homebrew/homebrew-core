class Idnits < Formula
  desc "Looks for problems in internet draft formatting"
  homepage "https://author-tools.ietf.org/idnits3/"
  url "https://registry.npmjs.org/@ietf-tools/idnits/-/idnits-3.1.0.tgz"
  sha256 "ddbafc75f62868c37cc3d5bc2075390cc23a71930114309588917484adf0f8cd"
  license "BSD-3-Clause"

  livecheck do
    url "https://registry.npmjs.org/@ietf-tools/idnits/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81129a1077c51a93d9c4c8b9e205ad9fca875934ff54537b469e33d9db818a36"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    resource "homebrew-test" do
      url "https://datatracker.ietf.org/doc/id/draft-tian-frr-alt-shortest-path-01.txt"
      sha256 "dd20ac54e5e864cfd426c7fbbbd7a1c200eeff5b7b4538ba3a929d9895f01b76"
    end

    testpath.install resource("homebrew-test")
    output = shell_output("#{bin}/idnits draft-tian-frr-alt-shortest-path-01.txt")
    assert_match(/\d+ errors?/, output)

    assert_match version.to_s, shell_output("#{bin}/idnits --version")
  end
end
