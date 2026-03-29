class BleSh < Formula
  desc "Bash Line Editor: syntax highlighting, auto suggestions, vim modes, etc."
  homepage "https://github.com/akinomyoga/ble.sh"
  url "https://github.com/akinomyoga/ble.sh/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "c49b22d48649efe40e52cbffbc7eae04c260d73b1cd2d632fc934149014b64fb"
  license "BSD-3-Clause"
  head "https://github.com/akinomyoga/ble.sh.git", branch: "master"

  depends_on "gawk" => :build
  depends_on "make" => :build

  on_macos do
    depends_on "bash"
  end

  def install
    args = ["INSDIR=#{pkgshare}"]
    args += %W[INSDIR_DOC=#{doc} INSDIR_LICENSE=#{prefix}] if build.head? # Not implemented in v0.3.4
    system "gmake", *args, "install"
  end

  def caveats
    <<~EOS
      To enable ble.sh by default, add the following line near the top of your ~/.bashrc:
        [[ $- == *i* ]] && source #{opt_pkgshare/"ble.sh"} --attach=none
      and add the following line at the end of your ~/.bashrc:
        [[ ${BLE_VERSION-} ]] && ble-attach
    EOS
  end

  test do
    # This software is impossible to test in an automated fashion;
    # the best we can do is test that it did in fact create the top-level script.
    assert_path_exists pkgshare/"ble.sh"
  end
end
