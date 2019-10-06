class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v1.18.3.tar.gz"
  sha256 "59fa9723919fbc42fc0b14f5240142ebb4b104fcac2c2aca7c802260b93cdaeb"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e8236cedf0efd243090e79372782600afe044a9f5cbb3b633937d8165ce391d" => :catalina
    sha256 "828d4faf3b5485d020abecce6490c08cff2d9e0c17c1c71f0250d86df2a13a0e" => :mojave
    sha256 "bd689f1d78f8f7ba8c345022abadbf7f98e86f69ce84b70120580049fe208862" => :high_sierra
    sha256 "061f6986e6825c20f1519c80a05eb7b229bb5c0fd2c227ed115d5f80ed0eb809" => :sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "PyYAML==3.13b1", buildpath
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
      (testpath/"f").write "hi\n"
      system "git", "add", "f"

      ENV["GIT_AUTHOR_NAME"] = "test user"
      ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
      ENV["GIT_COMMITTER_NAME"] = "test user"
      ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
      git_exe = which("git")
      ENV["PATH"] = "/usr/bin:/bin"
      system git_exe, "commit", "-m", "test"
    end
  end
end
