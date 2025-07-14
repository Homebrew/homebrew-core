class GitNow < Formula
  desc "Light, temporary commits for git"
  homepage "https://github.com/iwata/git-now"
  license "GPL-2.0-only"
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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "3ab8b27aefe8c9e0580cffc3c996028dbfcbca7f9c0c90a9141585d682f816b4"
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
