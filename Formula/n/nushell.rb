class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/refs/tags/0.115.0.tar.gz"
  sha256 "09859dde0207804abdd6f574c5b2f0946041555418bb6d3c44d4b9f86c7efd78"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    regex(/v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79f19134e6573994c2ed3b213e31f8aac187b5a427af426dd3a5b66d9a271916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37c9e358756531993dfb9ef3cbc3a8c35e2d612054243597ebb4c3e5ed30e3b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "548da87c6891bbd706c1d0b96b4ba1accf0a6509f6cbe2932594e8da552ce2fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ec30412fa15d29c9194ea3c7d953247e50a1ca838b742813312495559277503"
    sha256 cellar: :any,                 arm64_linux:   "f09ff3db10ab77e36cbe4ad4c2d1c930da730a15d9e2a59b471bee31c33923d8"
    sha256 cellar: :any,                 x86_64_linux:  "9c6be23a7e24245b94d211a566969478c777b91017c0c69b36e7f518ecbd4e86"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"

  on_linux do
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["NU_VENDOR_AUTOLOAD_DIR"] = HOMEBREW_PREFIX/"share/nushell/vendor/autoload"

    system "cargo", "install", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end
