require "language/node"

class Dockly < Formula
  desc "Immersive terminal interface for managing docker containers and services"
  homepage "https://lirantal.github.io/dockly/"
  url "https://registry.npmjs.org/dockly/-/dockly-3.24.2.tgz"
  sha256 "0c0004f0ea1f2bee8ba34a90374cd6434e55ae67baa31e7bdfcef8ac37014939"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "ae023c345074f52d3522d66ec2999a89ae86bd1d4b90eb067a7ab3d1b4f31e9c"
    sha256                               arm64_ventura:  "7beadd95cda6a81ab6ab51cf215301702ce7e42645f878643f47ba8ce1b1c816"
    sha256                               arm64_monterey: "3dc8ad524dadb4c55791be34ead567e338703d62b9064a6a0dcfca5ef072bbd8"
    sha256                               sonoma:         "f982cd4f2033b8fde04d87dc713a9174f28ec671898e04af18e3c319d355da83"
    sha256                               ventura:        "412a6b5fc6aeaf087c5f0d731f26646f69343edd19e5075c62ec7a7734d1ca9e"
    sha256                               monterey:       "82ed36eb2cbff2285cb3c941ae9d9f452085f43bf64a5095de465dbc2d1a4053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9564ca520624a1fe60e925e27aab6d61ee38fb3b20fcd55b2a111147e2ac59d"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    expected = if OS.mac?
      "Error: connect ENOENT"
    else
      "Error: connect EACCES"
    end
    assert_match expected, shell_output("#{bin}/dockly 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/dockly --version")
  end
end
