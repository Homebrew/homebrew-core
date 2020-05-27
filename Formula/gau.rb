class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v1.0.2.tar.gz"
  sha256 "058a0818b3b1465af9878566c6cb01e2b2835903b5630f63afb0645c07b28663"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fbfdf238dd7408adf09c159338c48e67ee9030f80f129a3b20683a960ab4531" => :catalina
    sha256 "d24c1d256af7be9370ec0d12d5deddabde47885d8d2b387ce5bfb6eb0a36e05c" => :mojave
    sha256 "67ece09c592ad7cdab9ec296e8fbff86fb23410a149aa9bb8f7a295d55661ab7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    output = shell_output("#{bin}/gau -providers wayback brew.sh")
    output.each_line do |line|
      assert_match %r{https?://brew\.sh(/|:)?.*}, line
    end
  end
end
