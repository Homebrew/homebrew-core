class Ijq < Formula
  desc "Interactive jq"
  homepage "https://sr.ht/~gpanders/ijq/"
  url "https://git.sr.ht/~gpanders/ijq",
      tag:      "v0.4.1",
      revision: "22034bea72c80db75cb8aa9fdd5808940bd45fd4"
  license "GPL-3.0-or-later"
  head "https://git.sr.ht/~gpanders/ijq", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "564d6d6f157700d1d0869d3340186bbf6bf8325314954804d8d9dbea45d9fe63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a7ea5d89f9eb6e575d2b4f3a5667364d03fccb1373207e6f6f226544f23a3d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f215c334ffea9e2ddf51319ac5b80a9b0ecab7e1d652ac8b72eb22534a8dae05"
    sha256 cellar: :any_skip_relocation, ventura:        "db72d1ed855f451cfb0e8e4f5ef6565e89b273e26d22635186aeb7a764eca033"
    sha256 cellar: :any_skip_relocation, monterey:       "47a030fd33f08d4888a73b3ac03135fb8493bfabeaeea13231143393cfb42be3"
    sha256 cellar: :any_skip_relocation, big_sur:        "16b7b6a8c95d9a8ba5b2f5610438c70b0b139e279910f88e823bb1239e53ed7d"
    sha256 cellar: :any_skip_relocation, catalina:       "022500c720f8926ae3e758f20c3290d60e0bdd4393ed118dc0c38c140d59cedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d748a577f085a1c6a7a1ee841c95b4805604f8e42b6531ada40ee82907e89cd0"
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
