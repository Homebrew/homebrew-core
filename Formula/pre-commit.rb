class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v1.8.0.tar.gz"
  sha256 "02a723530be38df0e6f34f2999b253127cac038b44b88080c686ac1920e90cb8"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d9931421baee580fa401851ff9510f5051085863d9b93a43de336b2f904a11d" => :high_sierra
    sha256 "1c5b5a8bb4d5c56ec2d90abc14c2b12073777faff84cd5b08327d98e6039a0df" => :sierra
    sha256 "17c25eb8c30add7fad39068f79a7341c5cdaab36edc7ad6ad6621b5da7a77c6c" => :el_capitan
  end

  depends_on "python"

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
