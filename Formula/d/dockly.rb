class Dockly < Formula
  desc "Immersive terminal interface for managing docker containers and services"
  homepage "https://lirantal.github.io/dockly/"
  url "https://registry.npmjs.org/dockly/-/dockly-3.24.7.tgz"
  sha256 "d529e0486fc708b60fed91ee9f4eec3a075a6e4780178f3ba16f1fd6b8f3b463"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "653e38b6f26732b4285baf114f43a8ed0cd43a703135f033b4b8b3949b04ef74"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "653e38b6f26732b4285baf114f43a8ed0cd43a703135f033b4b8b3949b04ef74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "653e38b6f26732b4285baf114f43a8ed0cd43a703135f033b4b8b3949b04ef74"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0a0587ea6a61da26542c9493ea65683f2c520a67b56641ed7151d03688f7f7fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0a0587ea6a61da26542c9493ea65683f2c520a67b56641ed7151d03688f7f7fe"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (formula_opt_bin("xsel")/"xsel").relative_path_from(linux_dir), linux_dir
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
