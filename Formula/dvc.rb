class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dvc.org"
  url "https://github.com/iterative/dvc/archive/0.90.2.tar.gz"
  sha256 "387c6436c92990b4dbcb0e8818877a1a519e1dea6bf82c7792e618a9da209ce8"

  bottle do
    cellar :any
    sha256 "3771c4d558ec5304167b642444da616c2024412638806140e34e16b878fe9c96" => :catalina
    sha256 "66886fc79b1fcf86edec3c053eae216e7da103011bfae5d67da8f9a031f22144" => :mojave
    sha256 "3ccbfca1dc420bb989d0e31c49e669154a522d33c30862b1315b921061052207" => :high_sierra
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
