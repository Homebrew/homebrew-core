class Crfsuite < Formula
  desc "Fast implementation of conditional random fields"
  homepage "https://www.chokkan.org/software/crfsuite/"
  url "https://github.com/downloads/chokkan/crfsuite/crfsuite-0.12.tar.gz"
  sha256 "e7fc2d88353b1f4de799245f777d90f3c89a9d9744ba9fbde8c7553fa78a1ea1"
  license "BSD-3-Clause"

  depends_on "liblbfgs"

  uses_from_macos "python" => :test

  resource "homebrew-conll2000-training-data" do
    url "https://www.cnts.ua.ac.be/conll2000/chunking/train.txt.gz"
    sha256 "bcbbe17c487d0939d48c2d694622303edb3637ca9c4944776628cd1815c5cb34"
  end

  def install
    args = std_configure_args
    args << "--disable-sse2" if Hardware::CPU.arm?

    system "./configure", *args
    system "make", "install"

    pkgshare.install "example"
  end

  test do
    resource("homebrew-conll2000-training-data").stage testpath

    # Use spawn instead of {shell,pipe}_output to directly read and write
    # from files. The data is too big to read into memory and then pass to
    # the command for this test to complete within the alloted timeout.
    command = ["python3", pkgshare/"example/chunking.py"]
    pid = spawn(*command, in: "train.txt", out: "train.crfsuite.txt")
    Process.wait(pid)

    system bin/"crfsuite", "learn", "--model", "CoNLL2000.model", "train.crfsuite.txt"
    assert_predicate testpath/"CoNLL2000.model", :exist?
  end
end
