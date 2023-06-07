class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https://github.com/tickstep/aliyunpan"
  url "https://github.com/tickstep/aliyunpan/archive/refs/tags/v0.2.7-1.tar.gz"
  sha256 "25ecc26b0212594cff485bbe878faf05831feb5165bdde355513f558bb2f4b88"
  license "Apache-2.0"
  head "https://github.com/tickstep/aliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "384505bd3adff369a42ea6cc7354c2b825a0066cda5a87b6905ccd409bf45c9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "384505bd3adff369a42ea6cc7354c2b825a0066cda5a87b6905ccd409bf45c9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "384505bd3adff369a42ea6cc7354c2b825a0066cda5a87b6905ccd409bf45c9c"
    sha256 cellar: :any_skip_relocation, ventura:        "52b80436a036263b15a9248486220d9216ac471d4cf581c1813200b2170040bd"
    sha256 cellar: :any_skip_relocation, monterey:       "52b80436a036263b15a9248486220d9216ac471d4cf581c1813200b2170040bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "52b80436a036263b15a9248486220d9216ac471d4cf581c1813200b2170040bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2e1d6b4d32d819117b1d0ddf73b973264790c522ccc657f543d9cb94dfad8d8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"aliyunpan", "run", "touch", "output.txt"
    assert_predicate testpath/"output.txt", :exist?
  end
end
