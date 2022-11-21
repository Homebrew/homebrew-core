class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v6.4.0/miller-6.4.0.tar.gz"
  sha256 "20a8687a0c5b5fedf4fc3a794ef1cee7e9872e87476e1f24bde8de25799f8c51"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08c93a4de09715b76f1cd57019a7b544fc44bb1b763df55ee146f16584215ba3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8a075f599c7d6a2f0ce13d802e47e9d4d59134cd93b598b09eb0473128fe7d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62d9c454310272bd9c0df8b30ae7022471348012d6381024ae83a5f7f0cec250"
    sha256 cellar: :any_skip_relocation, ventura:        "5c307e85a9e974acad07747be45afa15e5d8604019bcfa737cf29cebe53f6cb0"
    sha256 cellar: :any_skip_relocation, monterey:       "ed9eb29e632e431dda2df12ca7fb4455f497a3c82fe4fe669620c2472fddea97"
    sha256 cellar: :any_skip_relocation, big_sur:        "76478dd9ec9682086846c7818b863c4dfdef97c0ef5af409ec586d638ceacf1d"
    sha256 cellar: :any_skip_relocation, catalina:       "863621c64345cbe99cd55f536f3a60a2b82f11c5bfe426d75b938a85c9b21698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "703ae98f955923ebf40485811b7d7e1b26c7ca028e25e2152fb0192af4124612"
  end

  depends_on "go" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match "a\n1\n4\n", output
  end
end
