class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https://byobu.org"
  url "https://github.com/dustinkirkland/byobu/archive/refs/tags/7.22.tar.gz"
  sha256 "89793f984132732c4491e4a569431b799a40e397d670e86be92f3db70291955d"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4875a67d1e9daefb20ee910a995054fc5cf57af2c6b76a5d21e232f66320db39"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4875a67d1e9daefb20ee910a995054fc5cf57af2c6b76a5d21e232f66320db39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4875a67d1e9daefb20ee910a995054fc5cf57af2c6b76a5d21e232f66320db39"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "58df4c66613518bc0c8d3a49944e9d61f8d54a0ae5c1786cd0cf15c7fd858ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "58df4c66613518bc0c8d3a49944e9d61f8d54a0ae5c1786cd0cf15c7fd858ba9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "newt"
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

    byobu_python = Formula["newt"].deps
                                  .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                  .to_formula
                                  .libexec/"bin/python"

    lib.glob("byobu/include/*.py").each do |script|
      byobu_script = "byobu-#{script.basename(".py")}"

      libexec.install(bin/byobu_script)
      (bin/byobu_script).write_env_script(libexec/byobu_script, BYOBU_PYTHON: byobu_python)
    end
  end

  test do
    # Keep the tmux socket out of the shared `/tmp`, where the sandbox blocks connecting to stale ones
    ENV["TMUX_TMPDIR"] = testpath

    system bin/"byobu-status"
    assert_match "open terminal failed", shell_output("#{bin}/byobu-select-session 2>&1", 1)
  end
end
