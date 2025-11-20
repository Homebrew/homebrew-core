class Haraka < Formula
  desc "Fast, highly extensible, and event driven SMTP server"
  homepage "https://haraka.github.io/"
  url "https://registry.npmjs.org/Haraka/-/Haraka-3.1.1.tgz"
  sha256 "f86fb200cabc87c6665718919d42f95309f4387e4877b21557e4dc357bab285f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c58ec1564d087ad8c307ec4a210e3afb09e3b22b354a41a923807ddc461fe562"
    sha256                               arm64_sequoia: "c01ed2e0a60b29d2dec2852a9a84cb77579f5f88d6c1419a3853552626a2bc29"
    sha256                               arm64_sonoma:  "cd7537572473c6e1c2caf8f5707fba76e8f4fd4e6c767d0f7433c2776da55e91"
    sha256                               sonoma:        "6fe2852ccf3b1bce4c1a375d42841ecbd6bccfa659a4680f2f97a724483ff090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "807a9f5ac27cc0e11b0c14ed5205cce609c0fabd4aef3c513d36f2d056615d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37cb623d125fd204dd2bc44ea758884eb009caf830ec035b26514b75aeac4ed0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/haraka --version")

    system bin/"haraka", "--install", testpath/"config"
    assert_path_exists testpath/"config/README"

    output = shell_output("#{bin}/haraka --list")
    assert_match "plugins/auth", output
  end
end
