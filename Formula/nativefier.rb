require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-46.1.0.tgz"
  sha256 "d98da888437dbb8a7907feb0ba8c35c2b365622f55d88c181b519f80f9844d2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61e5cade0878df7c9e02dec9d39734e6d0c0ce83be6f20747a45f20cc241d8ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61e5cade0878df7c9e02dec9d39734e6d0c0ce83be6f20747a45f20cc241d8ea"
    sha256 cellar: :any_skip_relocation, monterey:       "0bc73892038e455a5a28edc89049a76ddf37937e7b87f92467b9630ed79a74b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bc73892038e455a5a28edc89049a76ddf37937e7b87f92467b9630ed79a74b6"
    sha256 cellar: :any_skip_relocation, catalina:       "0bc73892038e455a5a28edc89049a76ddf37937e7b87f92467b9630ed79a74b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61e5cade0878df7c9e02dec9d39734e6d0c0ce83be6f20747a45f20cc241d8ea"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
