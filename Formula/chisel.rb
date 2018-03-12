class Chisel < Formula
  desc "Collection of LLDB commands to assist debugging iOS apps"
  homepage "https://github.com/facebook/chisel"
  url "https://github.com/facebook/chisel/archive/1.8.0.tar.gz"
  sha256 "ccaafbbd06925cf08da0dd75ed82f7ddcde9273d877ba6c35b5a38fa351f439f"
  head "https://github.com/facebook/chisel.git"

  bottle do
    cellar :any
    sha256 "eba994a5b5d1880890bab0db0741ec7f6c65f3cc4a78957355714a84b76f2fa2" => :high_sierra
    sha256 "0cde612e49ea07f54a455161b9371f6b662b450169947103dddba66fb2debe6c" => :sierra
    sha256 "82f135ec7770a425e666086b7a5d6a31b086c10e11df42fbe849354592f26a3e" => :el_capitan
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
