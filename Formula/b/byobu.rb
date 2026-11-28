class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https://byobu.org"
  url "https://github.com/dustinkirkland/byobu/archive/refs/tags/7.24.tar.gz"
  sha256 "84151a9034070cb43de07642eeb37c2f60f8952c3b83526a9e1af1ec86dd4d39"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "3efc2557397d4c192185f6d803adfee17a4a9efbe1ef4d342442ab8981eed027"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cee1a38018295be3e68baa8e2397b8fa4d628cd62d8194b7a60217a1ffd6db41"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cee1a38018295be3e68baa8e2397b8fa4d628cd62d8194b7a60217a1ffd6db41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cee1a38018295be3e68baa8e2397b8fa4d628cd62d8194b7a60217a1ffd6db41"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a716df1cabfac057a3d9bfefc87da3a6e2e8ed47962df54d8c332edb05eac2ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a716df1cabfac057a3d9bfefc87da3a6e2e8ed47962df54d8c332edb05eac2ac"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "newt"
  depends_on "python@3.15"
  depends_on "tmux"

  on_macos do
    depends_on "coreutils"
    depends_on "gettext"
  end

  conflicts_with "ctail", because: "both install `ctail` binaries"

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    ENV.deparallelize { system "make", "install" }

    lib.glob("byobu/include/*.py").each do |script|
      byobu_script = "byobu-#{script.basename(".py")}"

      libexec.install(bin/byobu_script)
      (bin/byobu_script).write_env_script(libexec/byobu_script, BYOBU_PYTHON: python3)
    end
  end

  test do
    # Keep the tmux socket out of the shared `/tmp`, where the sandbox blocks connecting to stale ones
    ENV["TMUX_TMPDIR"] = testpath

    system bin/"byobu-status"
    assert_match "open terminal failed", shell_output("#{bin}/byobu-select-session 2>&1", 1)
  end
end
