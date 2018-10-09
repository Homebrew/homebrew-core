class Peg < Formula
  desc "Program to perform pattern matching on text"
  homepage "http://piumarta.com/software/peg/"
  url "http://piumarta.com/software/peg/peg-0.1.18.tar.gz"
  sha256 "20193bdd673fc7487a38937e297fff08aa73751b633a086ac28c3b34890f9084"

  bottle do
    cellar :any_skip_relocation
    sha256 "335fda7dd0c4cbd0a2c929daf19693729b3e1592f1880f5a1cb2ebd5ae587c3c" => :mojave
    sha256 "622cd7695294bcac63049e45e934ea1936dfc0f9373046dd028f63a3fe6fa2a4" => :high_sierra
    sha256 "15dfb147f388a8a486714d17d519a1ad1195f79bad5843d37726e8efaab1ae79" => :sierra
    sha256 "44d0ab83d1bc3ee71294d328dc70dd14206b8d8ddf05a195f2cdf354d746d5dc" => :el_capitan
    sha256 "9abe69e43c8e2672aa7b5b26df5c80976c2d0365b5d85d672e8948cebe88646f" => :yosemite
    sha256 "bbe71ecc8acb17bdf2538f41ae56472bc104a69e310cfd533565507c3468c53c" => :mavericks
  end

  def install
    system "make", "all"
    bin.install %w[peg leg]
    man1.install gzip("src/peg.1")
  end

  test do
    (testpath/"username.peg").write <<~EOS
      start <- "username"
    EOS

    system "#{bin}/peg", "-o", "username.c", "username.peg"

    assert_match /yymatchString\(yy, "username"\)/, File.read("username.c")
  end
end
