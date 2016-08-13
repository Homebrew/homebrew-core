class Autoenv < Formula
  desc "Per-project, per-directory shell environments"
  homepage "https://github.com/kennethreitz/autoenv"
  url "https://github.com/kennethreitz/autoenv/archive/v0.2.0.tar.gz"
  sha256 "8c360fde059a3b25d55ecab0c2ae90caf011a851aa3552bb42177eef650b46dc"
  head "https://github.com/kennethreitz/autoenv.git"

  bottle :unneeded

  def install
    prefix.install "activate.sh"
  end

  def caveats; <<-EOS.undent
    To finish the installation, source activate.sh in your shell:
      source #{opt_prefix}/activate.sh
    EOS
  end
end
