class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/archive/refs/tags/v6.19.0.tar.gz"
  sha256 "032cd07d947986dfe9a97ed4f4ea5fb8bf354dce81229b58acad9e89e941a59e"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e538784e5552fd5024bcc5a052231e568c701e1b36b15a0814febe1f779def0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f246b7da4a59a982573387f88e7b92d244e11dc092f8ea4c92340adba474711e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23deb8beff0645d80df7ed4b292fd378c67bb8ebdc1da64e5b2aaed7f6ba5509"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b65e135a8f91e8c6e3929e444076ddeda3b27725d862c69f463d69906a5c61a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d76acffad3057ecbc5baa796cb522acfeeda54a3b7dd649b3621f095f4510a4d"
    sha256 cellar: :any,                 x86_64_linux:  "241dcc75ed9fa599ec15b07c6931dfa1ce40ed8fe71c316a025d2a5527f8c7fc"
  end

  depends_on "go" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~CSV
      a,b,c
      1,2,3
      4,5,6
    CSV
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match "a\n1\n4\n", output
  end
end
