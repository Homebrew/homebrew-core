require "language/node"

class Dockly < Formula
  desc "Immersive terminal interface for managing docker containers and services"
  homepage "https://lirantal.github.io/dockly/"
  url "https://registry.npmjs.org/dockly/-/dockly-3.24.1.tgz"
  sha256 "1f004c72e1958f386f00efdccc467a06ade3c1f8ad205dbbaaff1a6b6625686a"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "1ec4174e3f9fe4abd5f2a9d6f4fe83d9e3b9d958092744be9bcf9b16b7cd995e"
    sha256                               arm64_ventura:  "b0da0adaefe8bd1678031a237404976e6009b7b67b1a0702f19e952038b92a71"
    sha256                               arm64_monterey: "e639fc69080e217984b13c655264bdf39b7ca58ca66baf4f545049251411601d"
    sha256                               sonoma:         "c48c4b7d2899ceea0f09c576e168b7165c1cc8d952ee0e4749a6632575fde49e"
    sha256                               ventura:        "73880ec079cfc0e88762edfee5f419820edd704e85f79a27ef6bfc90d2a01424"
    sha256                               monterey:       "3d9a63cec2a47907cd3adbdb308284be7cd57e44f7de219b844583ddf949fec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "886c00f4442fd7f85862ff02465ad7186a8e758ba90300959dfad62d42f225be"
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
