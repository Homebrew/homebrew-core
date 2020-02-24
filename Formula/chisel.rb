class Chisel < Formula
  desc "Collection of LLDB commands to assist debugging iOS apps"
  homepage "https://github.com/facebook/chisel"
  url "https://github.com/facebook/chisel/archive/2.0.0.tar.gz"
  sha256 "e2ededa84fbe68904f01ff12f2c9607a87626e33c17ed35989278f15c3543385"
  head "https://github.com/facebook/chisel.git"

  bottle do
    cellar :any
    sha256 "77635fc7ebef3451a9f81eb942d380c39990866eb7e1ca134efdcd9bc0c3f02c" => :catalina
    sha256 "458800fbdac364534efa7105a17294125b58b5f929b6993bc7893e01a157e6cc" => :mojave
    sha256 "596ef36832b696a736d8b47b6d0a27893dc74be2e999e80dbb7893ec79ca9ea5" => :high_sierra
  end

  def install
    libexec.install Dir["*.py", "commands"]

    # == LD_DYLIB_INSTALL_NAME Explanation ==
    # This make invocation calls xcodebuild, which in turn performs ad hoc code
    # signing. Note that ad hoc code signing does not need signing identities.
    # Brew will update binaries to ensure their internal paths are usable, but
    # modifying a code signed binary will invalidate the signature. To prevent
    # broken signing, this build specifies the target install name up front,
    # in which case brew doesn't perform its modifications.
    system "make", "-C", "Chisel", "install", "PREFIX=#{lib}", \
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
