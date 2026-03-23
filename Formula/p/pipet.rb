class Pipet < Formula
  desc "Swiss-army tool for web scraping, made for hackers"
  homepage "https://github.com/bjesus/pipet"
  url "https://github.com/bjesus/pipet/archive/refs/tags/0.3.0.tar.gz"
  sha256 "9fb35bcc4be8b7655a4075c3b2bf7b0368ae7bb97e9e6dbbcf00422c8e18cc6b"
  license "MIT"
  head "https://github.com/bjesus/pipet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63abd2f8e1acdd4351fa4e9f87a98b41574785f4a841347110b6ab01b3037eb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "560a89ed526f7be6a13af3eaaa88fa4bbd108a488a251d1f562a4ef7af9a5e38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "560a89ed526f7be6a13af3eaaa88fa4bbd108a488a251d1f562a4ef7af9a5e38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "560a89ed526f7be6a13af3eaaa88fa4bbd108a488a251d1f562a4ef7af9a5e38"
    sha256 cellar: :any_skip_relocation, sonoma:        "80d52f08edf8293bf7c71ae75dfff7e79df2575251bff9f6c9b5041a0168d8e6"
    sha256 cellar: :any_skip_relocation, ventura:       "80d52f08edf8293bf7c71ae75dfff7e79df2575251bff9f6c9b5041a0168d8e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "155b71857798f70e3829c1bbf5eb418530a7c97a6eb00c39d2685c41aaf0657f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "524fe9b1d57b91baafd8ebad6440a9745e6659fdf95ddf2c956226f649ebbc1f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pipet"
  end

  test do
    (testpath/"example.pipet").write <<~EOS
      curl https://example.com
      head > title
    EOS

    assert_match "Example Domain", shell_output("#{bin}/pipet example.pipet")
  end
end
