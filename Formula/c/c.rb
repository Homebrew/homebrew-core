class C < Formula
  desc 'Compile and execute C "scripts" in one go'
  homepage "https://github.com/ryanmjacobs/c"
  url "https://github.com/ryanmjacobs/c/archive/v0.14.tar.gz"
  sha256 "2b66d79d0d5c60b8e6760dac734b8ec9a7d6a5e57f033b97086821b1985a870b"
  license "MIT"
  head "https://github.com/ryanmjacobs/c.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61a07ffb8d1f341bf995e6aae382b6053d2cb8ba7864c02d6832e988f3df795f"
  end

  def install
    bin.install "c"
  end

  test do
    (testpath/"test.c").write("int main(void){return 0;}")
    system bin/"c", testpath/"test.c"
  end
end
