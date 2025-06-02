class Pdfcrack < Formula
  desc "PDF files password cracker"
  homepage "https://pdfcrack.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.20/pdfcrack-0.20.tar.gz"
  sha256 "7b8b29b18fcd5cb984aeb640ee06edf09fede4709b59c32fee4f2d86860de5b4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2b014cb16fb3c9c3d8d587c792f9d94d2c1c7efc6032cdffab864c3e8c93786f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db85d14c7177eed695a8947e0d8ffb49c9378ac5b5a704a27a9375736b063e2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fedea0ab3ba0838a429e8ed114d60d4f58da156c5c744fc2d20346e3a48a7f06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cca12550f347ca49f8a11858013225bd36cd851c4ad43505d4ba6b205914c31a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b8b8b66dc3d864bb5bc16363fb64aa1fbc467f29fd41bd0184b23da9a37fc41"
    sha256 cellar: :any_skip_relocation, sonoma:         "923edc7797d1589d947b9b885980d7b767a16aa6eaeeac4c230f7ad9a9a3e2c9"
    sha256 cellar: :any_skip_relocation, ventura:        "9867baec308baa565b939bc7699ebf762a3a9f7c7b31bd2fd0411dff01725390"
    sha256 cellar: :any_skip_relocation, monterey:       "7bb75581bf7567d9992fffc9cbfa6742c43e4bd41b6adbe4906f441666a98e76"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc978f3e5078c22cc095f8b6947d6e09ef903720e9c5035a178594abe2ccd573"
    sha256 cellar: :any_skip_relocation, catalina:       "e333186830217c419886e8c068204c355044d70ff45e6210498894f8da12d13d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "461c25aa48ea7ea33702e9e5a196a25ff329fd9da902a007821a61109eac8b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac7d9f63248e7c6828bc9c9e0df709dad76b2e3954246fb7c382da62d6ca4859"
  end

  def install
    system "make", "all"
    bin.install "pdfcrack"
  end

  test do
    system bin/"pdfcrack", "--version"
  end
end
