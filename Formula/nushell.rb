class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.68.1.tar.gz"
  sha256 "d3719f5b3eca5dee6215e39fe1da1b559d49837f0baf18c7edc14f1719c986bb"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "82f2dd3790efb74342fddaa107180213aebad0298c3d845fb709925479dcda29"
    sha256 cellar: :any,                 arm64_big_sur:  "fa0b734ff1b15e68a59362b3dc28490de026fb959687c2a8ba51d58c0906dcc6"
    sha256 cellar: :any,                 monterey:       "c2aaf841c8f1259c24ea8431f8ccbf5876a08e31f65266fcc8a87310c4e774ef"
    sha256 cellar: :any,                 big_sur:        "dc8af0acb89a1097042bbb1f210fafd9745e78c5eb51be0722045e91eab3f351"
    sha256 cellar: :any,                 catalina:       "20431e3a21a51160b41a0136652ada235d7f81d6f78094a15126119d4916e88e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "285043a9c9a1493938e67b1e236477d75acdf947718a0d5bea07302a1cfaad6c"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c \'{ foo: 1, bar: homebrew_test} | get bar\'", nil)
  end
end
