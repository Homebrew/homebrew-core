class Miniconda < Formula
  desc "Continuum Analytics Miniconda"
  homepage "https://conda.io/miniconda.html"
  url "https://repo.anaconda.com/miniconda/Miniconda3-4.6.14-MacOSX-x86_64.sh"

  # Miniconda3 (aka Python 3 envs), exact version not managed by Brew
  version "3"

  sha256 "2ec958508139289df3b5e2c10257311af4f0ebf39242f61d39f11e7fa14ebb40"

  def install
    system "/bin/bash",
      "Miniconda3-4.6.14-MacOSX-x86_64.sh",
      "-b", "-p", "#{prefix}/opt"

    bin.install_symlink Dir["#{prefix}/opt/condabin/*"]
  end

  test do
    # Make sure our bin runs
    system "#{bin}/conda", "info"

    # Ensure it is our bin
    assert_equal "#{prefix}/opt\n", shell_output("#{bin}/conda info --base")
  end
end
