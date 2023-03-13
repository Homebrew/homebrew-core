require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-5.8.2.tgz"
  sha256 "4c82131b60c6753b2497b0ce91f971ae496ea5370cc2f8c34e4b592ae68a4a6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c45b0746941e58ef315325345b552c889a8391e3a4f917c32d712e87820f9cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c45b0746941e58ef315325345b552c889a8391e3a4f917c32d712e87820f9cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c45b0746941e58ef315325345b552c889a8391e3a4f917c32d712e87820f9cb"
    sha256 cellar: :any_skip_relocation, ventura:        "f2d1f6e6a765d913729c210660f63e7270f276f35532ece2c543e9cb5a09dec7"
    sha256 cellar: :any_skip_relocation, monterey:       "f2d1f6e6a765d913729c210660f63e7270f276f35532ece2c543e9cb5a09dec7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2d1f6e6a765d913729c210660f63e7270f276f35532ece2c543e9cb5a09dec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c85a64608e27ff98865741915e6cccfb1f4d6ee33d1a8e744acea979c764cb"
  end

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
