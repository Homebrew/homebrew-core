class DotVault < Formula
  desc "CLI for DotVault — secure environment variable management"
  homepage "https://github.com/lucerowb/dot-vault"
  url "https://registry.npmjs.org/@lucerowb/dot-vault/-/dot-vault-0.2.7.tgz"
  sha256 "75d52137cc138fb2de711457712c39144c98bf52b1e3ad8a604eaf4d19808a28"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/@lucerowb/dot-vault/latest"
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
    assert_match version.to_s, shell_output("#{bin}/dv --version")
  end
end
