class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v1.4.3.tar.gz"
  sha256 "6e69e4b44a968a9378e0f349697245ab80f9afd18c421dfa55b3a6762f7ff97b"

  bottle do
    cellar :any_skip_relocation
    sha256 "38f2bbdb24016edba5b8944eba6aed9456768731d973f4efe275e11b3f8e99af" => :high_sierra
    sha256 "d6a01e9c9f590674c1ba865a8a74a54abf32805b68c34c052b84e7c4bbcf0f42" => :sierra
    sha256 "c215f3a05d75470b7ef3e8bbd2f1f2bf1a69ff62132482900eb632d2d2f7ba4c" => :el_capitan
  end

  depends_on "python3"

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
