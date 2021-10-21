class Dstat < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "Versatile resource statistics tool (the real one, not the Red Hat clone)"
  homepage "https://github.com/dstat-real/dstat"
  url "https://github.com/dstat-real/dstat/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "4fbd58f3461c86d09a3ab97472aa204de37aa33d31a0493a3e5ed86a2045abea"
  license "GPL-2.0-only"
  head "https://github.com/dstat-real/dstat.git", branch: "master"

  depends_on :linux
  depends_on "python@3.9"
  depends_on "six"

  def install
    virtualenv_create(libexec, "python3")
    rewrite_shebang python_shebang_rewrite_info("#{libexec}/bin/python3"), "dstat"

    # NOTE: add pkgshare to dstat plugin path
    inreplace "dstat", "/usr/share/dstat/", pkgshare.to_s

    cp "dstat", "dstat.py"
    bin.install "dstat"
    man1.install "docs/dstat.1"
    pkgshare.install Dir["plugins/*.py"]
    pkgshare.install "dstat.py"
  end

  test do
    output = shell_output("#{bin}/dstat 1 1").strip
    assert_match "--total-cpu-usage-- -dsk/total- -net/total- ---paging-- ---system--", output
  end
end
