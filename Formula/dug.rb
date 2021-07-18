class Dug < Formula
    desc "Global DNS progagation checker that gives pretty output"
    homepage "https://dug.unfrl.com"
    url "https://github.com/unfrl/dug/releases/download/0.0.75/dug.0.0.75.osx-x64.tar.gz"
    version "0.0.75"
    sha256 "8a8f355cd5972a32b250028340659a9633ac936615fc7e4bbb5ae4234738e29e"
    license :cannot_represent
  
    def install
      libexec.install Dir["*"]
      bin.write_exec_script (libexec/"dug")
  
      bottle :unneeded
    end
  
    test do
      assert_equal "0.0.75", shell_output("#{bin}/dug --version").strip
    end
  end
  