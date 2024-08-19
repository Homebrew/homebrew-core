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

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5008304a966c3efaed02ef949fdfce9aa2df1e0d7dd78df531e2a635602d0bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5008304a966c3efaed02ef949fdfce9aa2df1e0d7dd78df531e2a635602d0bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5008304a966c3efaed02ef949fdfce9aa2df1e0d7dd78df531e2a635602d0bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5008304a966c3efaed02ef949fdfce9aa2df1e0d7dd78df531e2a635602d0bd"
    sha256 cellar: :any_skip_relocation, ventura:        "c5008304a966c3efaed02ef949fdfce9aa2df1e0d7dd78df531e2a635602d0bd"
    sha256 cellar: :any_skip_relocation, monterey:       "c5008304a966c3efaed02ef949fdfce9aa2df1e0d7dd78df531e2a635602d0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eebc36e5f38171ab8bcc008399c5e639f3a71f91fcc19477283c98f1a87f470"
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
    assert_predicate testpath/".gitignore", :exist?
    assert_predicate testpath/"bower.json", :exist?
  end
end
