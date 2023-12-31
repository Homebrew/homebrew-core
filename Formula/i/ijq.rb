class Ijq < Formula
  desc "Interactive jq"
  homepage "https://sr.ht/~gpanders/ijq/"
  url "https://git.sr.ht/~gpanders/ijq",
      tag:      "v1.0.0",
      revision: "ddee00530d57f230c5ea9fe2fa2b4e3cfe956565"
  license "GPL-3.0-or-later"
  head "https://git.sr.ht/~gpanders/ijq", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a764dacbf5ab5c61bf13695b337d2c4ffbe67db4ed2e308fdc2a7b6d4f79aca9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb4cc8e835b1ff4dd0d065afb99b9d83b0079957226cff08f6e2c6c49ec6f069"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f73974125d8ca66c06c606a8a99524e83c153f8e1e2c3124895eacfe8385118a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1916b8419209827ee3bac4c9e67e03fef06cae1ab80a7a350a9b4dae6bae625d"
    sha256 cellar: :any_skip_relocation, ventura:        "8174cdf57b348cd12ffe56071d06d0f74e3e176395f31ecc6d9432cabf3f4e94"
    sha256 cellar: :any_skip_relocation, monterey:       "28a82710e2b81ef3c02b7b17ae4895e6e0f168c4f1a6133d4948d53d3807e54a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b2f3a49b305a7bb88cc81b86d8b0a396245fc7d24d7b272710154cb54b0e03e"
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
