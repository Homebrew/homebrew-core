class Memphis < Formula
 desc "Greetings from Memphis - CLI"
 homepage "https://github.com/Memphis-OS/memphis-cli"
 url "https://github.com/Memphis-OS/memphis-cli/releases/download/v0.1.0-beta/memphis.tar.gz"
 sha256 "7879853453675db79c39bce6037cd137874c5cc21ec09999d1c3e9483efde20b"
 license "MIT"
 version "v0.1.0-beta"
 
 def install
   bin.install "memphis"
 end
end

