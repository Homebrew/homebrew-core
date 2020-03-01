class HgFastExport < Formula
  include Language::Python::Virtualenv

  desc "Fast Mercurial to Git converter"
  homepage "https://repo.or.cz/fast-export.git"
  url "https://github.com/frej/fast-export/archive/v200213.tar.gz"
  sha256 "358f501ab301c31525f23f29e94708fe361ed53e99b5fb9c77fbca81ff1a2b76"

  bottle do
    cellar :any_skip_relocation
    sha256 "e205898991d6d4befff9295792a2d0e87cde9f24b02ad75ce2b6c43b17619e14" => :catalina
    sha256 "6a408b86b22768b990daf8d2d55c2767cfd93cc1208e5f1c322aa2d19e310a14" => :mojave
    sha256 "7ee154d85bb7a2ec5c45cb394296282a55f62b741b6434a68a1e966a7009a69d" => :high_sierra
  end

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
