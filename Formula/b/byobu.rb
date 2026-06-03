class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https://github.com/dustinkirkland/byobu"
  url "https://github.com/dustinkirkland/byobu/archive/refs/tags/7.6.tar.gz"
  sha256 "2cb144fba2a5b835bde571537c31129b259e507613d86e127863e1f2f2797c5c"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d38ba976b061d110d0e8a7bb051932ae1fcfccc241dfeb52b3047ef28b7cb6ef"
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
