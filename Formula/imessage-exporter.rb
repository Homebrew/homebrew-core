class ImessageExporter < Formula
  desc "Command-line tool to export and inspect local iMessage database"
  homepage "https://github.com/ReagentX/imessage-exporter"
  url "https://github.com/ReagentX/imessage-exporter/archive/refs/tags/1.3.0.tar.gz"
  sha256 "fc792712b2fa626d4f33d43b08dd10464fba678facf405e2ca5eee379644a73d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5107697578ef50c50eaa96fc572ff6dfd6ad477469ccc65476184cdc6be9e3a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d049520a7da585837699574936090921b4621fea121eaa8e93853046b21dde30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dc61a0de88f161ac5e98ffdc7b688c8063088c43de0fe19ec4cbb9e7957fcfd"
    sha256 cellar: :any_skip_relocation, ventura:        "f607bf7e7dd4bc07fd360639a9fb7736b6533e7802f284b1e80b21f0ee65ef45"
    sha256 cellar: :any_skip_relocation, monterey:       "95448e351df2072e79216c56dac29d117a3e57aff6fcfe271a6e8c3b3afaae76"
    sha256 cellar: :any_skip_relocation, big_sur:        "db01f275c7a6efd34db4fa1853f15096db033d5e87d67c4addb4edb4647291d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ef7703455226796dcfa0f1c0e714d523954b22a85113b1046b503b0917c9940"
  end

  depends_on "rust" => :build

  def install
    # manifest set to 0.0.0 for some reason, matching upstream build behavior
    # https://github.com/ReagentX/imessage-exporter/blob/develop/build.sh
    inreplace "imessage-exporter/Cargo.toml", "version = \"0.0.0\"",
                                              "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "imessage-exporter")
  end

  test do
    assert_match version.to_s, shell_output(bin/"imessage-exporter --version")
    assert_match "Unable to launch", shell_output(bin/"imessage-exporter --diagnostics 2>&1")
  end
end
