class Onelogin < Formula
  desc "CLI for Using OneLogin"
  homepage "https://github.com/onelogin/onelogin"
  url "https://github.com/onelogin/onelogin/archive/refs/tags/v0.1.14.tar.gz"
  sha256 "d25d41b51f4a1464675b88e7de8026331d2a1ac2611674a9064535ccd5001ba5"
  license "Apache-2.0"
  head "https://github.com/onelogin/onelogin.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle :unneeded
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    bin_path = buildpath/"src/github.com/onelogin/onelogin"
    # Copy all files from their current location (GOPATH root)
    # to $GOPATH/src/github.com/onelogin/onelogin
    bin_path.install Dir["*"]
    cd bin_path do
      # Install the compiled binary into Homebrew's `bin` - a pre-existing
      # global variable
      system "go", "build", "-o", bin/"onelogin", "."
    end
  end

  test do
    # "2>&1" redirects standard error to stdout. The "2" at the end means "the
    # exit code should be 2".
    assert_match "Welcome to OneLogin", shell_output("#{bin}/onelogin 2>&1")
  end
end
