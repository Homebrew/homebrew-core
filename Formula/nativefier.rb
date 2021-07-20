require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-45.0.0.tgz"
  sha256 "dbe38a880655e48986cfab25f22f1f8c3a2a46eb9879f2bd77c827257227efd7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8fc21bff12d7e40f9d4ed1e919de69624725b01b8a8ec6212477e33a285b741f"
    sha256 cellar: :any_skip_relocation, big_sur:       "d404f2188715ffe4db5f1d785b300e05d39d8f7d228a4dd929d223953497fe58"
    sha256 cellar: :any_skip_relocation, catalina:      "d404f2188715ffe4db5f1d785b300e05d39d8f7d228a4dd929d223953497fe58"
    sha256 cellar: :any_skip_relocation, mojave:        "d404f2188715ffe4db5f1d785b300e05d39d8f7d228a4dd929d223953497fe58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13199ff7a2406340d6f4704080b583df5be3903b3ffd87ff452c2cbe9df4d0d6"
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
