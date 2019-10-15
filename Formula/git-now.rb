class GitNow < Formula
  desc "Light, temporary commits for git"
  homepage "https://github.com/iwata/git-now"
  url "https://github.com/iwata/git-now.git",
      :tag      => "v0.1.1.0",
      :revision => "a07a05893b9ddf784833b3d4b410c843633d0f71"
  head "https://github.com/iwata/git-now.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e1c1c1575d8fe84137bfc93b688babf32b59935f0a312c9d5ad844b8ab651e9" => :catalina
    sha256 "4bef5c0beb701451614ec9a8e961940ce3caa50e09b8a7faf1b80dad10dace75" => :mojave
    sha256 "ad78d8ab5cf008375bdeb03f0b1289733fba33fac43535f38117e5d8af50f06b" => :high_sierra
    sha256 "ffde5161accdd2bab777e610302f858e1bf9e17f0ee1a41fb4e7b33a0d9f5eb4" => :sierra
    sha256 "7126e867e543659b9750041412e737407fb94f9dbb38fea1edf16cec8027aa64" => :el_capitan
    sha256 "748cd8691ad94b407f892ffa7f8e12c183b7326208efd9ac6dafbe1b8fda9565" => :yosemite
    sha256 "c19eda078da8974bde40ee07eac5701e9295d56bd59a6d18ea21c3d337b50e02" => :mavericks
  end

  depends_on "gnu-getopt"

  def install
    system "make", "prefix=#{libexec}", "install"

    (bin/"git-now").write <<~EOS
      #!/bin/sh
      PATH=#{Formula["gnu-getopt"].opt_bin}:$PATH #{libexec}/bin/git-now "$@"
    EOS

    zsh_completion.install "etc/_git-now"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    touch "file1"
    system "git", "init"
    system "git", "add", "file1"
    system bin/"git-now"
    assert_match "from now", shell_output("git log -1")
  end
end
