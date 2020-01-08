class GitPlus < Formula
  desc "Git utilities: git multi, git relation, git old-branches, git recent"
  homepage "https://github.com/tkrajina/git-plus"
  url "https://github.com/tkrajina/git-plus/archive/v0.3.3.tar.gz"
  sha256 "42c296bd21f2c0ad5312b39c312718fba1b0a55d5cd167aa385fcdafe0fa1748"
  head "https://github.com/tkrajina/git-plus.git"

  bottle :unneeded

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

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
