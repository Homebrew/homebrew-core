class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  url "https://registry.npmjs.org/bower/-/bower-1.8.14.tgz"
  sha256 "00df3dcc6e8b3a4dd7668934a20e60e6fc0c4269790192179388c928553a3f7e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "27cfa496a8b8d490f3dd6eeba235e0b64561da813d88bcc89fe1b03114dc091c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e6ffe74d0b616fce08852c9b92624829b867149d990bd0bcc36f45b802e0016"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e6ffe74d0b616fce08852c9b92624829b867149d990bd0bcc36f45b802e0016"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e6ffe74d0b616fce08852c9b92624829b867149d990bd0bcc36f45b802e0016"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e40c22cfa9946b9bf731953c371b9793808754b6903037276be89b7c4c479b5"
    sha256 cellar: :any_skip_relocation, ventura:        "5e40c22cfa9946b9bf731953c371b9793808754b6903037276be89b7c4c479b5"
    sha256 cellar: :any_skip_relocation, monterey:       "5e40c22cfa9946b9bf731953c371b9793808754b6903037276be89b7c4c479b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "771a98dc248a03e567cf7dee75bb4711dd51ff9ff36df04186642c86d8f22263"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"bower", "install", "jquery"
    assert_predicate testpath/"bower_components/jquery/dist/jquery.min.js", :exist?, "jquery.min.js was not installed"
  end
end
