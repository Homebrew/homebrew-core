require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-5.7.0.tgz"
  sha256 "3add7ce952b0cbc4138986cbe0764767939f71ce4fb1898dd487f42ad17dbe09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "96e11f28d24dd5050085aef60bbe72791ca77bebeeb8b1db91eb13960f43507c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e5a925fd6688be20cf8c5b931a6edb423bf3e7dbef8a3cfc4347c6ce86f0ab70"
    sha256 cellar: :any_skip_relocation, catalina:      "e5a925fd6688be20cf8c5b931a6edb423bf3e7dbef8a3cfc4347c6ce86f0ab70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c1883f188bed11649803d4732f861e8193cae22e6d165b65d569f22c8c55abd"
  end

  depends_on "psc-package" => :build
  depends_on "pulp" => :build
  depends_on "purescript" => :build
  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    assert_equal "120000 ms", shell_output("#{bin}/insect '1 min + 60 s -> ms'").chomp
    assert_equal "299792458 m/s", shell_output("#{bin}/insect speedOfLight").chomp
  end
end
