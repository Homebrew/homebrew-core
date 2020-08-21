class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/v0.3.7.tar.gz"
  sha256 "424dde6592c99468dce19c1302222a15ccc2367f0c908ee2147709398ce6497b"
  license "MIT"
  head "https://github.com/mattn/goreman.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8a7091a9c750d499f4b7857d606f3ce762bd4901b715ce1e4c0a45196487615f" => :catalina
    sha256 "1d38d14fa4f2a7e7f77f7d2609bf1b289fcea8622f23829f4e35da2a499a3d35" => :mojave
    sha256 "44a066817f8aedad724ff2e2bdf9be53fbacaf1f8939462d6e5dc89bd7f3fab0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"goreman"
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end
