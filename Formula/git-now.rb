class GitNow < Formula
  desc "Light, temporary commits for git"
  homepage "https://github.com/iwata/git-now"
  license "GPL-2.0"
  head "https://github.com/iwata/git-now.git", branch: "master"

  stable do
    # We switched from git url to tarballs & resource as submodule fetch fails without
    # https://github.com/iwata/git-now/commit/9beab94649afd0822c2c5bf38db9963c7a997ba7
    # but we cannot apply a patch before `git submodule update --init --recursive`.
    url "https://github.com/iwata/git-now/archive/refs/tags/v0.1.1.0.tar.gz"
    sha256 "b6f6b9221dcab10de44514575f54e80daf825dc9f5a72262f5708a7432aa087f"

    resource "shFlags" do
      url "https://github.com/nvie/shFlags/archive/refs/tags/1.0.3.tar.gz"
      sha256 "5e8dfddc7eb5f51f56b74b9d928cb64bd969e0d511c3efab5c0a6c2433c6fedd"
    end

    # Fix error on Linux due to /bin/sh using dash
    patch do
      url "https://github.com/iwata/git-now/commit/be74736cb95e8213cd06cc6fe85f467e26b9a3c2.patch?full_index=1"
      sha256 "6f13e7baeb0160e937221e51cd5736fabc57e3b8ba9309b88a8b17b5d14bb767"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cbebffb09635dd83022c86c6317b6af0e795914942f968e62aafccdcca171364"
    sha256 cellar: :any_skip_relocation, big_sur:       "3345a93f778e582278cd7e86321e2b776c1c85375d1a9e326c098fc970f5cf54"
    sha256 cellar: :any_skip_relocation, catalina:      "5e1c1c1575d8fe84137bfc93b688babf32b59935f0a312c9d5ad844b8ab651e9"
    sha256 cellar: :any_skip_relocation, mojave:        "4bef5c0beb701451614ec9a8e961940ce3caa50e09b8a7faf1b80dad10dace75"
    sha256 cellar: :any_skip_relocation, high_sierra:   "ad78d8ab5cf008375bdeb03f0b1289733fba33fac43535f38117e5d8af50f06b"
    sha256 cellar: :any_skip_relocation, sierra:        "ffde5161accdd2bab777e610302f858e1bf9e17f0ee1a41fb4e7b33a0d9f5eb4"
    sha256 cellar: :any_skip_relocation, el_capitan:    "7126e867e543659b9750041412e737407fb94f9dbb38fea1edf16cec8027aa64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "164fbdd1cfb2b36c92f068263061b7b81d08fbe728b197661cbb3202b84d0d96"
  end

  depends_on "gnu-getopt"

  def install
    (buildpath/"shFlags").install resource("shFlags")
    system "make", "prefix=#{libexec}", "install"
    (bin/"git-now").write_env_script libexec/"bin/git-now", PATH: "#{Formula["gnu-getopt"].opt_bin}:$PATH"
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
