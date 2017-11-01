class GitCinnabar < Formula
  include Language::Python::Virtualenv
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar.git",
      :tag => "0.4.0",
      :revision => "6d374888ff0287517084c0ec7573963961f6acec"
  head "https://github.com/glandium/git-cinnabar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f366361f486082b1f4cd2defa48af5efd1942dd8b848dc66d0560787fd06fbe" => :high_sierra
    sha256 "03f64128f2ec4fb5f0597157c90db69e273cfa1ed521aa928c700b9de1f176d4" => :sierra
    sha256 "5942ec7cbd204c8e6e691b48c38333f0e7cea11cd2a80714fe3952a1f14507e9" => :el_capitan
    sha256 "3f5f4a461ab56361b323f2a934704652011c8a4ada7da719c957005ced268f67" => :yosemite
  end

  devel do
    url "https://github.com/glandium/git-cinnabar.git",
        :tag => "0.5.0b1",
        :revision => "f4ce4ab5ae70c11f00fbc0964e1edf4da6fe7657"
    version "0.5.0b1"
  end

  depends_on :hg

  conflicts_with "git-remote-hg", :because => "both install `git-remote-hg` binaries"

  resource "hg" do
    url "https://mercurial-scm.org/release/mercurial-4.3.3.tar.gz"
    sha256 "47a63c78698bc735667984bbc5b76619ff29a38d742f20cdf9f44cce59752374"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install resource("hg")
    inreplace "git-cinnabar", /#!.*/, "#!#{libexec}/bin/python"
    inreplace "git-remote-hg", /#!.*/, "#!#{libexec}/bin/python"
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, :PYTHONPATH => prefix)
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
