class HgGit < Formula
  desc "Git Mercurial Plugin"
  homepage "http://hg-git.github.io"
  url "https://bitbucket.org/durin42/hg-git/get/0.8.5.tar.bz2"
  sha256 "60bf47386fc0c9eef809344ff2be98eaa5add822f70dd25670470d06673fe2c4"
  head "https://bitbucket.org/durin42/hg-git", :using => :hg

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on :hg

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    (testpath/".hgrc").write <<-EOS.undent
      [extensions]
      hggit=
    EOS
    system "hg", "clone", "git://github.com/schacon/hg-git.git"
  end
end
