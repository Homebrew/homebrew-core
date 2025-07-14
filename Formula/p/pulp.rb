class Pulp < Formula
  desc "Build tool for PureScript projects"
  homepage "https://github.com/purescript-contrib/pulp"
  url "https://registry.npmjs.org/pulp/-/pulp-16.0.2.tgz"
  sha256 "a70585e06c1786492fde10c9c1bc550405351c2e6283bbd3f777a6a04fb462ff"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{href=.*?/package/pulp/v/(\d+(?:[.-]\d+)+)["']}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "0de9300b253bf5fa068c578ff479fc02a5371a7367bfaf9b3563122b8163ae4a"
  end

  depends_on "bower"
  depends_on "node"
  depends_on "purescript"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulp --version")

    system bin/"pulp", "init"
    assert_path_exists testpath/".gitignore"
    assert_path_exists testpath/"bower.json"
  end
end
