class Photon < Formula
  desc "Typed terminal UI for the Photon Dashboard"
  homepage "https://github.com/photon-hq/spectrum-ts"
  url "https://registry.npmjs.org/@photon-ai/cli/-/cli-0.2.1.tgz"
  sha256 "ea253caa31f166500a481f90861736310d6a60c39100137568e9c823b110769b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@photon-ai/cli/latest"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/photon --version")
    assert_match "photon", shell_output("#{bin}/photon --help")
  end
end
