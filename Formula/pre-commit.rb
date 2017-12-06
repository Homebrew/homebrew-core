class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v1.4.1.tar.gz"
  sha256 "cc908bc0ca5f77cdb6d05d090f9b09a18514de8c82dfea3b8edffda06871f0e6"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4a69f93b11e059940078da025601d1a9e0636f20142d9a503b51f19ba2441826" => :high_sierra
    sha256 "628fb9d80a7c5bbb236675cb779f29f69106507c409f45d9f85df1e41e78c323" => :sierra
    sha256 "27861ce49ed1948c6818823cee25b939c870d82e0f7ad0f1a41777a371c2cdde" => :el_capitan
  end

  depends_on :python3

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "pre-commit"
    venv.pip_install_and_link buildpath
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?
      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
    inreplace lib_python_path/"orig-prefix.txt",
              Formula["python3"].opt_prefix, Formula["python3"].prefix.realpath
  end

  test do
    testpath.cd do
      system "git", "init"
      (testpath/".pre-commit-config.yaml").write <<~EOS
        -   repo: https://github.com/pre-commit/pre-commit-hooks
            sha: v0.9.1
            hooks:
            -   id: trailing-whitespace
      EOS
      system bin/"pre-commit", "install"
      system bin/"pre-commit", "run", "--all-files"
    end
  end
end
