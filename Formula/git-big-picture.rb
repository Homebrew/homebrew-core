class GitBigPicture < Formula
  include Language::Python::Virtualenv
  desc "Visualization tool for Git repositories"
  homepage "https://github.com/esc/git-big-picture"
  url "https://github.com/esc/git-big-picture/archive/v0.10.1.tar.gz"
  sha256 "e23d8ba4ef6e37a0e97ae33a0ff0e084e4fe08d4e20497cde1984ef1df3ef596"
  head "https://github.com/esc/git-big-picture.git"

  depends_on "python@2" if MacOS.version <= :snow_leopard

  def install
    virtualenv_install_with_resources
  end

  test do
    Dir.chdir(testpath) do
      system "git", "clone", "https://github.com/esc/git-big-picture.git", "repo"
      Dir.chdir(testpath/"repo") do
        system "git", "big-picture", "-f", "png", "-o", "git-big-picture.png"
        assert_predicate testpath/"repo/git-big-picture.png", :exist?
      end
    end
  end
end
