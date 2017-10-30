class Chisel < Formula
  desc "Collection of LLDB commands to assist debugging iOS apps"
  homepage "https://github.com/facebook/chisel"
  url "https://github.com/facebook/chisel/archive/1.5.0.tar.gz"
  sha256 "370c20a18bfa92c7c635cd04a9a199b078a829a60832e4e87ba5c4034b471856"
  head "https://github.com/facebook/chisel.git"

  bottle :unneeded

  def install
    libexec.install Dir["*.py", "commands"]
    prefix.install "PATENTS"
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
