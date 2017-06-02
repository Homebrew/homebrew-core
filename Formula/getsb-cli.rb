# Documentation: http://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class GetsbCli < Formula
  desc "Getsb is a command line tool for sending HTTP request."
  homepage "https://github.com/nsheremet/getsb-cli"
  url "https://github.com/nsheremet/getsb-cli/archive/v0.1.0.tar.gz"
  sha256 "6c33daa56a654350f256def358a93201f395aae01b7564531ac65c0b6b846977"

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/getsb"
  end

  test do
    system bin/"getsb", "GET", "https://brew.sh"
  end
end
