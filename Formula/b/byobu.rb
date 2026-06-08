class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https://github.com/dustinkirkland/byobu"
  url "https://github.com/dustinkirkland/byobu/archive/refs/tags/7.8.tar.gz"
  sha256 "3ec8bfef81818a1c50c278317a536ca1d4564cae89c14a46f1f943bab97e6dba"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e985779f09279950b10372e611f2662a4b7915bc5a5f2d8afc35c3ceb03e0f2"
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

  def install
    cp "./debian/changelog", "./ChangeLog"
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
    system bin/"byobu-status"
    assert_match "open terminal failed", shell_output("#{bin}/byobu-select-session 2>&1", 1)
  end
end
