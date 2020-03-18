class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://github.com/iterative/dvc/archive/0.90.0.tar.gz"
  sha256 "8fe146e334f07bc023a2bf3c3afc2245e161c70f83786efe334d67cca781cd9a"

  bottle do
    cellar :any
    sha256 "43c387eee1a1c2bf5d7131d4e48080574899d6bacda8b8175f3f4598f60f9069" => :catalina
    sha256 "105edc7ae5d80119dac38064663fe284dae3b1e3e2b44ff6605b0cfd5b07c1ee" => :mojave
    sha256 "32b3842170e748b7e9782fbae908425193560bfdb8f22fe1eec80fbdb312e317" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "openssl@1.1"
  # `apache-arrow` currently depends on Python 3.7
  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")

    system libexec/"bin/pip", "install",
      "--no-binary", ":all:",
      # NOTE: we will uninstall Pillow anyway, so there is no need to build it
      # from source.
      "--only-binary", "Pillow",
      "--ignore-installed",
      # NOTE: pyarrow is already installed as a part of apache-arrow package,
      # so we don't need to specify `hdfs` option.
      ".[gs,s3,azure,oss,ssh,gdrive]"

    # NOTE: dvc depends on asciimatics, which depends on Pillow, which
    # uses liblcms2.2.dylib that causes troubles on mojave. See [1]
    # and [2] for more info. As a workaround, we need to simply
    # uninstall Pillow.
    #
    # [1] https://github.com/peterbrittain/asciimatics/issues/95
    # [2] https://github.com/iterative/homebrew-dvc/issues/9
    system libexec/"bin/pip", "uninstall", "-y", "Pillow"
    system libexec/"bin/pip", "uninstall", "-y", "dvc"

    # NOTE: dvc uses this file [1] to know which package it was installed from,
    # so that it is able to provide appropriate instructions for updates.
    # [1] https://github.com/iterative/dvc/blob/0.68.1/dvc/utils/pkg.py
    File.open("dvc/utils/build.py", "w+") { |file| file.write("PKG = \"brew\"") }

    venv.pip_install_and_link buildpath

    bash_completion.install "scripts/completion/dvc.bash" => "dvc"
    zsh_completion.install "scripts/completion/dvc.zsh"
  end

  test do
    system "#{bin}/dvc", "--version"
  end
end
