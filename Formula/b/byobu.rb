class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https://byobu.org"
  url "https://github.com/dustinkirkland/byobu/archive/refs/tags/7.23.tar.gz"
  sha256 "2c6bb133d717cd3333fbddef22fc27f1d8914ffd066c1b044b233186cbb35aa0"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0beba6cf94fa9eaf79c2b2f5ae40b9bfa86937ef2ac09fc59267cd7ab5ccfb56"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0beba6cf94fa9eaf79c2b2f5ae40b9bfa86937ef2ac09fc59267cd7ab5ccfb56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0beba6cf94fa9eaf79c2b2f5ae40b9bfa86937ef2ac09fc59267cd7ab5ccfb56"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7d7400f007bb160889a74e39210f61c95f1c89a91ca95d4ba33aba2bc304fece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7d7400f007bb160889a74e39210f61c95f1c89a91ca95d4ba33aba2bc304fece"
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
