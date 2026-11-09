class HerdrCore < Formula
  desc "Terminal runtime for coding agents"
  homepage "https://herdr.dev/core"
  url "https://github.com/herdrdev/herdr-core/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "12833c90516cf70f8489085323434244f300cd5a8437f667ff9f5b932c906302"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on "zig@0.16" => :build

  # The vendor/ghostty submodule, which GitHub's source tarball leaves empty.
  # Keep it at the commit the release tag pins.
  resource "ghostty" do
    url "https://github.com/ghostty-org/ghostty/archive/1e5cdb865807abc990181efb8ebfa9122955cce2.tar.gz"
    sha256 "3157b5a1ddc11040763a772a154b709ed7939a9626c3d1cd9207ebbab3fd2811"
  end

  # Backport of https://github.com/herdrdev/herdr-core/pull/182: without it, the
  # Ghostty build fails when only the Command Line Tools are installed.
  patch do
    url "https://github.com/herdrdev/herdr-core/commit/287d6ab3eb35447f2b2ce69197dcdcc2c20fd265.patch?full_index=1"
    sha256 "35868ddc40659d2bd7c4cd6db14f3db4fa1e41ef7ab43783225795dd0949df22"
  end

  deny_network_access!

  def fetch
    resource("ghostty").stage buildpath/"vendor/ghostty"
    system "cargo", "fetch", *std_cargo_fetch_args
    cd "vendor/ghostty" do
      system "zig", "build", "--fetch=all"
    end
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/herdr-core")
    bin.install_symlink "herdr-core" => "hc"
    doc.install "crates/herdr-core/THIRD-PARTY-NOTICES"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hc --version")

    ENV["HOME"] = testpath
    ENV["XDG_CONFIG_HOME"] = testpath/"config"
    ENV["XDG_STATE_HOME"] = testpath/"state"
    ENV["XDG_RUNTIME_DIR"] = testpath/"run"
    ENV["HC_SESSION"] = "brew"
    [ENV["XDG_CONFIG_HOME"], ENV["XDG_STATE_HOME"], ENV["XDG_RUNTIME_DIR"]].each { |dir| mkpath dir }

    assert_match "hello-from-hc", shell_output("#{bin}/hc run echo hello-from-hc")
  ensure
    system bin/"hc", "server", "stop"
  end
end
