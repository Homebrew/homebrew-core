class MinLang < Formula
  desc "Small but practical concatenative programming language and shell"
  homepage "https://min-lang.org"
  url "https://github.com/h3rald/min/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "017178f88bd923862b64f316098772c1912f2eef9304c1164ba257829f1bbfc2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2399b604ba7108b1c8e442000b82bda95bde645208b035bd215555ebd63464ac"
    sha256 cellar: :any,                 arm64_sequoia: "c1963c58890c7c684d3692d5ef1a4e0879201169fe7dca1dbef10703c6c78f60"
    sha256 cellar: :any,                 arm64_sonoma:  "2ac6374d96c02d278f0e7e606026caf2dc6995ebad326d9e68cf16fe1c628fd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "907853439795ba7c476b5e4e5038d1bcb5e1a19e2dcdff6d96854170e01a37a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2644d1463518048a8b360765ffc3c564e5f3dd5815d904927ca356e610e20e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b778ef9b5fa15904a6d65ace8ebf92f82742bc7ab2562cc4658214c159f201a"
  end

  depends_on "nim"
  depends_on "openssl@3"

  def install
    system "nimble", "build", '--passL:"-lssl -lcrypto"'
    bin.install "min"
  end

  test do
    testfile = testpath/"test.min"
    testfile.write <<~EOS
      sys.pwd sys.ls (fs.type "file" ==) filter '> sort
      puts!
    EOS
    assert_match testfile.to_s, shell_output("#{bin}/min test.min")
  end
end
