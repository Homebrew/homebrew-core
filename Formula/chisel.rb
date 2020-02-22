class Chisel < Formula
  desc "Collection of LLDB commands to assist debugging iOS apps"
  homepage "https://github.com/facebook/chisel"
  url "https://github.com/facebook/chisel/archive/2.0.0.tar.gz"
  sha256 "e2ededa84fbe68904f01ff12f2c9607a87626e33c17ed35989278f15c3543385"
  head "https://github.com/facebook/chisel.git"

  bottle do
    cellar :any
    sha256 "e77606622ec541a1a02ab155ec4cb6b0ca6ae653cd4bb6aea2b7c7f3262a139d" => :catalina
    sha256 "29c17de80f280349701f53c1103e9654717c6f70d4075ae3da640bec2c04ba74" => :mojave
    sha256 "8886d6402a50e4b920f5d55809ec9b51e934b7073f02bdf112ab98fb4466b665" => :high_sierra
    sha256 "85d31eb6edf4a19059f7e3c019a07ad2462bb1df42cab53eac24baef3a3c703e" => :sierra
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
