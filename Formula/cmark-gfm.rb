class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.28.3.gfm.16.tar.gz"
  version "0.28.3.gfm.16"
  sha256 "5594e42f13e529e2530bcc8e4681832e888714d5c89f4eaf3adefc731e21a3e2"

  bottle do
    cellar :any
    sha256 "7dccae726f0a0c40db8d58f3de0bdf91b88f1ca8417e46edf088ce75ea045c0a" => :mojave
    sha256 "ee27c6d97d907803261684e2e66b33eaba0f1c9a5178061b89edc9fdb4cd1102" => :high_sierra
    sha256 "b2093ad9e295ff9a466c01b9fb77d3a5965b4a791071360f4d1fcaec08a4b0e7" => :sierra
    sha256 "12651aa1954ef96a027b484011d1426b35868f4d11a4bdaf845f67cdf7e10d26" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  conflicts_with "cmark", :because => "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
