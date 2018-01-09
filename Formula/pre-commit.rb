class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "http://pre-commit.com/"
  url "https://github.com/pre-commit/pre-commit/archive/v1.4.5.tar.gz"
  sha256 "ee3981ec02c5e8d4d4fa76ee06d3205bd4b7e49d9c3d28a8a74c0bdcaecb47eb"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ceacecb5b13c6222b7c153e821a53a7f02e797b41d02d3daadd2ad29a66f178" => :high_sierra
    sha256 "eb354ddf8f6d98d665b81b8bd860d61a698a9d211224d944005642b6e48ae3ee" => :sierra
    sha256 "78d6d0258c4c0a11df501e4de4fc2002e00a8cd6c4262875e61536ed694a4a4a" => :el_capitan
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
