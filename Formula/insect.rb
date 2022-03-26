require "language/node"

class Insect < Formula
  desc "High precision scientific calculator with support for physical units"
  homepage "https://insect.sh/"
  url "https://registry.npmjs.org/insect/-/insect-5.7.0.tgz"
  sha256 "3add7ce952b0cbc4138986cbe0764767939f71ce4fb1898dd487f42ad17dbe09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5393913ddbe2ef4498f86fb0f782cb45be1ecae5313f62399199cdc133e67fe5"
    sha256 cellar: :any_skip_relocation, big_sur:       "70715bec1be0f0400629325d2637e931ca4c91342acf9a5de34197e3a81e7576"
    sha256 cellar: :any_skip_relocation, catalina:      "30d7f0f2e26a504fafc8444b90e243680186c1d10c5ef05e505bb712a3d2d543"
    sha256 cellar: :any_skip_relocation, mojave:        "b0d541a0e1a22cd63cd3a5ade24de85b9630e1b5d12154063c001d4d21fa81f4"
    sha256 cellar: :any_skip_relocation, high_sierra:   "0604c43c2cb219d817eb9129ee501dff2f1d206c8da539eb062c88ba4ed6518d"
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
