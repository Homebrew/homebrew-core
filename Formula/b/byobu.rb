class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https://github.com/dustinkirkland/byobu"
  url "https://github.com/dustinkirkland/byobu/archive/refs/tags/6.10.tar.gz"
  sha256 "55ad76dbe1bf5be183e4742cd3bdbf1b7cf5468339de35ceb9cfdd05709e8dba"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "307888338bac3600b1805eda416940ee4c78089b70abc1dc21d49c69d8ad94fb"
  end

  head do
    url "https://github.com/dustinkirkland/byobu.git", branch: "master"
  end

  depends_on "gettext"
  depends_on "newt"
  depends_on "tmux"
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_macos do
    depends_on "coreutils"
  end

  conflicts_with "ctail", because: "both install `ctail` binaries"

  def install
    cp "./debian/changelog", "./ChangeLog"
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"

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
