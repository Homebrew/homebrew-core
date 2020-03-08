class BleSh < Formula
  desc "Bash Line Editor: syntax highlighting, auto suggestions, vim modes, etc."
  homepage "https://github.com/akinomyoga/ble.sh"
  url "https://github.com/akinomyoga/ble.sh/archive/v0.3.2.tar.gz"
  sha256 "c0b9a1521e375bcc38252cb0863404a246fe54c1619c58657253698220e78c68"
  head "https://github.com/akinomyoga/ble.sh.git"

  keg_only "this formula puts files in lib that shouldn't be linked"

  depends_on "gawk" => :build
  depends_on "make" => :build

  uses_from_macos "bash"

  def install
    system Formula["make"].bin/"gmake"
    system Formula["make"].bin/"gmake", "INSDIR=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      To enable ble.sh by default, add the following to the beginning of your ~/.bash_profile:
        [[ $- == *i* ]] && source #{opt_prefix/"ble.sh"} --noattach
      and also add the following to the end of your ~/.bash_profile:
        ((_ble_bash)) && ble-attach

      We highly recommend using a more up-to-date version of bash than the one macOS comes with by default.  You can install that with:
        brew install bash
    EOS
  end

  test do
    # This software is impossible to test in an automated fashion;
    # the best we can do is test that it did in fact create the top-level script.
    assert_predicate prefix/"ble.sh", :exist?
  end
end
