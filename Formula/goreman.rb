class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/v0.3.14.tar.gz"
  sha256 "1d1c24abf32baee8f52865cb8e43056a4b0a30e646b282b17e117b6fcc6cce3d"
  license "MIT"
  head "https://github.com/mattn/goreman.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c095f2360084a1477500f8d6684accceb6f09b22805a8d44ad08f9a64753ef7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "986155fa8952bfc2f2e642a3dd8fef50d273fe086aa7a4c33774a4d13f4eca18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4b24f1d784da2b808ef927b8432d0a8cc12ba573f4a5e714be0eaeb735eb8c1"
    sha256 cellar: :any_skip_relocation, ventura:        "2c132a1b7cdd09a873a83f992013144ed7fbf3d0fc980380f43fd7d0dfbc4776"
    sha256 cellar: :any_skip_relocation, monterey:       "8a43d0685955570af59741794d37c4b215860b2b3c9d60823774b2c047a1cf98"
    sha256 cellar: :any_skip_relocation, big_sur:        "bab40f093c03c2e988489dee4ab7387df524831e21c502c9585846f41c3a7735"
    sha256 cellar: :any_skip_relocation, catalina:       "31c67a12dc71a363b8ba88fbeff4c15eabc40aeb8cc194aabb123752744fc673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6966ffced430d09be24f06c54954cdfba15a149e9d1d518c883a7ff3a9f150b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end
