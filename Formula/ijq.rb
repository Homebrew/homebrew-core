class Ijq < Formula
  desc "Interactive jq"
  homepage "https://sr.ht/~gpanders/ijq/"
  url "https://git.sr.ht/~gpanders/ijq",
      tag:      "v0.4.1",
      revision: "22034bea72c80db75cb8aa9fdd5808940bd45fd4"
  license "GPL-3.0-or-later"
  head "https://git.sr.ht/~gpanders/ijq", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a81009cc8896c8f0e4e3913cfb15c0abec6dc1d6bd7cedbaf6e9e1f282aad14b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c84ae1e5d2a6947754f6ea4c781deb79c1d5f83629cbe7bc739317ca1c258acd"
    sha256 cellar: :any_skip_relocation, monterey:       "b3e5371d6d94ae47d0db2134e516d4b36e3948e1d07dd96e588d734d0f3db6f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "103e78eb9bfae3f35e75b285e78919d4aec337e7b652c8a4cd529707b8c34ebe"
    sha256 cellar: :any_skip_relocation, catalina:       "30cf0caa810fe9122fd9f9c2fa5e0a447eef3fadfc8a1b39c490b6392272497e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "049216e8a10b91e825fb7d50565a6b70b78e6341d19eed93e0c86749d01779a6"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build
  depends_on "jq"

  uses_from_macos "expect" => :test

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    ENV["TERM"] = "xterm"

    (testpath/"filterfile.jq").write '["foo", "bar", "baz"] | sort | add'

    (testpath/"ijq.exp").write <<~EOS
      #!/usr/bin/expect -f
      proc succeed {} {
        puts success
        exit 0
      }
      proc fail {} {
        puts failure
        exit 1
      }
      set timeout 5
      spawn ijq -H '' -M -n -f filterfile.jq
      expect {
        barbazfoo   succeed
        timeout     fail
      }
    EOS
    system "expect", "-f", "ijq.exp"
  end
end
