class Chisel < Formula
  desc "Collection of LLDB commands to assist debugging iOS apps"
  homepage "https://github.com/facebook/chisel"
  url "https://github.com/facebook/chisel/archive/1.7.1.tar.gz"
  sha256 "952354d358dea8407b36effff2dd6acd81af733ca920ec2a97e62235f5bcc749"
  head "https://github.com/facebook/chisel.git"

  bottle do
    cellar :any
    sha256 "7cc6e9eef63e47cd4ddc61b89d59f80f175512e0abd8029a29f48b8de31bbe84" => :high_sierra
    sha256 "b4fc8a9967bc88e73e82a07e14cf8b675312c4d0de09a566835fb3f04845a0a4" => :sierra
    sha256 "554afb79cd556e6a40c901e6fa6ea36021e5425e54a146c525f380f22ad12923" => :el_capitan
  end

  def install
    libexec.install Dir["*.py", "commands"]
    prefix.install "PATENTS"

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
