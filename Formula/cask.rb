class Cask < Formula
  desc "Emacs dependency management"
  homepage "https://cask.readthedocs.org/"
  url "https://github.com/cask/cask/archive/v0.8.0.tar.gz"
  sha256 "e118c5c459735e1a23324a395e7adc64535822a44fc8a07d9e5b2251daeaf6a9"
  head "https://github.com/cask/cask.git"

  bottle :unneeded

  depends_on :emacs => ["24", :run]

  def install
    bin.install "bin/cask"
    prefix.install "templates"
    # Lisp files must stay here: https://github.com/cask/cask/issues/305
    prefix.install Dir["*.el"]
    elisp.install_symlink "#{prefix}/cask.el"
    elisp.install_symlink "#{prefix}/cask-bootstrap.el"

    # Stop cask performing self-upgrades.
    touch prefix/".no-upgrade"
  end

  test do
    (testpath/"Cask").write <<-EOS.undent
      (source gnu)
      (depends-on "chess")
    EOS
    system bin/"cask", "install"
    (testpath/".cask").directory?
  end
end
