class Chisel < Formula
  desc "Collection of LLDB commands to assist debugging iOS apps"
  homepage "https://github.com/facebook/chisel"
  url "https://github.com/facebook/chisel/archive/1.7.0.tar.gz"
  sha256 "46647976361119570de95d40bd77defdbbc7aa67747c278093b3658b7ed7a124"
  head "https://github.com/facebook/chisel.git"

  bottle :unneeded

  def install
    libexec.install Dir["*.py", "commands"]
    prefix.install "PATENTS"
    # Specify install name to prevent homebrew from modifying the library after
    # it's been code signed.
    system 'make', '-C', 'Chisel', 'install', "PREFIX=#{lib}", \
      "LD_DYLIB_INSTALL_NAME=#{opt_prefix}/lib/Chisel.framework/Chisel"
  end

  def caveats; <<~EOS
    Add the following line to ~/.lldbinit to load chisel when Xcode launches:
      command script import #{opt_libexec}/fblldb.py
    EOS
  end

  test do
    xcode_path = `xcode-select --print-path`.strip
    lldb_rel_path = "Contents/SharedFrameworks/LLDB.framework/Resources/Python"
    ENV["PYTHONPATH"] = "#{xcode_path}/../../#{lldb_rel_path}"
    system "python", "#{libexec}/fblldb.py"
  end
end
