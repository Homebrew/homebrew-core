class Hmmer < Formula
  desc "Build profile HMMs and scan against sequence databases"
  homepage "http://hmmer.org/"
  url "http://eddylab.org/software/hmmer/hmmer-3.3.2.tar.gz"
  sha256 "92fee9b5efe37a5276352d3502775e7c46e9f7a0ee45a331eacb2a0cac713c69"
  license "BSD-3-Clause"

  livecheck do
    url "http://eddylab.org/software/hmmer/"
    regex(/href=.*?hmmer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "0663d641b8c378d675b29c085eac9473db9c043a23193c46ae109316c5aced17"
    sha256 cellar: :any_skip_relocation, monterey:     "85399c5d79f4d97c5e1755688bc29ce31985a6a489d8c859a5e080e5a564ad98"
    sha256 cellar: :any_skip_relocation, big_sur:      "af45073d7f7d1ce1231c03381c5e50af9de1d6773762a65200a6067b84590c9d"
    sha256 cellar: :any_skip_relocation, catalina:     "6bd9bbe8efab7ec335de773b059922574ec2a89d755afd09dc475f6b251fb886"
    sha256 cellar: :any_skip_relocation, mojave:       "f170a16fcc45126a552ae1b0fdd3cbb25e73f77a53f10011e5c304afa69694fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3ae7f46facfc99d3247a3d30db78ea54bc79fcf255ed4c099eb4ddca023d7458"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    doc.install "Userguide.pdf", "tutorial"
  end

  test do
    assert_match "PF00069.17", shell_output("#{bin}/hmmstat #{doc}/tutorial/Pkinase.hmm")
  end
end
