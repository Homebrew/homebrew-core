class Docutils < Formula
  include Language::Python::Virtualenv

  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.18/docutils-0.18.tar.gz"
  sha256 "c1d5dab2b11d16397406a282e53953fe495a46d69ae329f55aa98a5c4e3c5fbb"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbbb998101da6c04be8dbe625f981a53b7370f78b0bbe6cd07975d5e76175fd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbbb998101da6c04be8dbe625f981a53b7370f78b0bbe6cd07975d5e76175fd9"
    sha256 cellar: :any_skip_relocation, monterey:       "4c5ed1d9463f3bfd739a8a29f99dcabc39ccc0457a367377db4ffe7d8ad44135"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c5ed1d9463f3bfd739a8a29f99dcabc39ccc0457a367377db4ffe7d8ad44135"
    sha256 cellar: :any_skip_relocation, catalina:       "4c5ed1d9463f3bfd739a8a29f99dcabc39ccc0457a367377db4ffe7d8ad44135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c0cc4f7f747a5345b8c70c9e2926d8b7a22fd12eaa067c635559d8315a087cb"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources

    Dir.glob("#{libexec}/bin/*.py") do |f|
      bin.install_symlink f => File.basename(f, ".py")
    end
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
