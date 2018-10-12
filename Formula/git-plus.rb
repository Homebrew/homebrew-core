class GitPlus < Formula
  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://github.com/tkrajina/git-plus/archive/v0.3.1.tar.gz"
  sha256 "ec650cca2e5d26d89f099e3124fbf927c5ab31a56b8c2191b723c4b6a6a50b21"
  head "https://github.com/tkrajina/git-plus.git"

  bottle :unneeded

  depends_on "python@2" # does not support Python 3

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    mkdir "testme" do
      system "git", "init"
      touch "README"
      system "git", "add", "README"
      system "git", "commit", "-m", "testing"
      rm "README"
    end

    assert_match "D README", shell_output("#{bin}/git-multi")
  end
end
