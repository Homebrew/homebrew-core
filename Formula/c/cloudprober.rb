class Cloudprober < Formula
  desc "Active monitoring software to detect failures before your customers do"
  homepage "https://cloudprober.org"
  url "https://github.com/cloudprober/cloudprober/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "13c013f9c80abc011646f4c3e90bc9e68ed3d94ce6b2794934545d980060d5c5"
  license "Apache-2.0"
  head "https://github.com/cloudprober/cloudprober.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e923f5b34eb57c92978ae7dfcce8ab45bbab441a8ded599cc0bdf6c1119b3b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2bc69518da27afc30c0eb0b84e790fbbaf163b033133a5afdda42ffbdb5ec4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d12c706149ed1e4bdace0aafbda897697533acbf832823635c9c7cf95cd1eec"
    sha256 cellar: :any_skip_relocation, sonoma:        "afb895b466e687920d5ff8ddfaa196a1050f1d5757aba492aad11667aced9006"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc28a3c158fd2a1419a3cfdb1441cda59899b1dcabaf3bcb2576469c4bfd79d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5742ff10c19afda49fa419e1f5bcbd98bda19f34ffb61cf4d4e2378045aef3a0"
  end

  depends_on "go" => :build

  def install
    system "make", "cloudprober", "VERSION=v#{version}"
    bin.install "cloudprober"
  end

  test do
    io = IO.popen("#{bin}/cloudprober --logtostderr", err: [:child, :out])
    io.any? do |line|
      line.include?("Initialized status surfacer")
    end
  end
end
