require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-5.8.2.tgz"
  sha256 "4c82131b60c6753b2497b0ce91f971ae496ea5370cc2f8c34e4b592ae68a4a6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e1ce2b1855759ca4646126c396456041a213bda6920e279b3a315d71eac5b3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e1ce2b1855759ca4646126c396456041a213bda6920e279b3a315d71eac5b3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e1ce2b1855759ca4646126c396456041a213bda6920e279b3a315d71eac5b3d"
    sha256 cellar: :any_skip_relocation, ventura:        "0a6cbc1e1b097216ab2cb8cd984239ecb9596d4fb46d258ef146ecaa60bcc995"
    sha256 cellar: :any_skip_relocation, monterey:       "0a6cbc1e1b097216ab2cb8cd984239ecb9596d4fb46d258ef146ecaa60bcc995"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a6cbc1e1b097216ab2cb8cd984239ecb9596d4fb46d258ef146ecaa60bcc995"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d460b29a0e541d84a666d6138a510a75d044d4411fd4410f27c96e364fec2c7"
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
