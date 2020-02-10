class HgFastExport < Formula
  include Language::Python::Virtualenv

  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  url "https://github.com/frej/fast-export/archive/v190913.tar.gz"
  sha256 "f1d30976d242f679676d8e6d54eff108ef785edd918b7a3c3195e1d510923bcc"
  revision 1

  uses_from_macos "python@2" # does not support Python 3

  # mercurial 5.3 support will be added in the next release
  # Ref https://github.com/frej/fast-export/pull/197
  resource "hg" do
    url "https://www.mercurial-scm.org/release/mercurial-5.2.2.tar.gz"
    sha256 "ffc5ff47488c7b5dae6ead3d99f08ef469500d6567592a25311838320106c03b"
  end

  def install
    ENV.delete("PYTHONPATH")
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resource("hg").stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }

    libexec.install Dir["*"]

    bins = %w[hg-fast-export.py hg-fast-export.sh hg-reset.py hg-reset.sh hg2git.py]
    bins.each do |f|
      (bin / f).write_env_script(libexec / f, :PYTHONPATH => ENV["PYTHONPATH"])
    end
  end

  test do
    hg = "#{libexec}/vendor/bin/hg"

    mkdir testpath/"hg-repo" do
      system hg, "init"
      (testpath/"hg-repo/test.txt").write "Hello"
      system hg, "add", "test.txt"
      system hg, "commit", "-u", "test@test", "-m", "test"
    end

    mkdir testpath/"git-repo" do
      system "git", "init"
      system "git", "config", "core.ignoreCase", "false"
      system "hg-fast-export.sh", "-r", "#{testpath}/hg-repo"
      system "git", "checkout", "HEAD"
    end

    assert_predicate testpath/"git-repo/test.txt", :exist?
    assert_equal "Hello", (testpath/"git-repo/test.txt").read
  end
end
