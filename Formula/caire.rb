class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/v1.3.3.tar.gz"
  sha256 "04437f6cb9ae065b06a8a13de16f5ae54c76bcae54dd9711c0b26b5eaada5564"
  license "MIT"
  head "https://github.com/esimov/caire.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ded687dbc6a1b29621ce5825eff96f3f379fba2a18d8eb73769888d28396e81e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73072aefdcf24ecb76c8d5e7bf6625e907bda57741efe2ede003aa270a158b0e"
    sha256 cellar: :any_skip_relocation, monterey:       "14b94b36f92c80b8eb4298fa6dc8d9f145ca68c22c2002debaa13f54bd413f72"
    sha256 cellar: :any_skip_relocation, big_sur:        "854c0b0a7ce773711eef0a9611d6b3c2359ad4a80b012261ae2311c47bb12ba7"
    sha256 cellar: :any_skip_relocation, catalina:       "1b1524eeceeb2b8b0ae42256a8c1498a6a6422b127b78d12027a6ed72f00d4db"
    sha256 cellar: :any_skip_relocation, mojave:         "da4468121d98b8d58ff70b4d5baaccd464702c89b542625457f47a83e312958f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "103687d17c57aec33924e7917f9ca8a5b5deab1263c0a5a2f0806e1cdc58798a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/caire"
  end

  test do
    system bin/"caire", "-in", test_fixtures("test.png"), "-out", testpath/"test_out.png",
           "-width=1", "-height=1", "-perc=1"
    assert_predicate testpath/"test_out.png", :exist?
  end
end
