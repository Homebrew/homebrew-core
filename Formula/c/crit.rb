class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "bdc1c495fe65950111abefed6c14ca1707a97b00fc5637dab4d351768dfabdc2"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88de62e36b0b0ecb043b7fac8dc2caee5af5326871e98deb59cfd00c7f1dab6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88de62e36b0b0ecb043b7fac8dc2caee5af5326871e98deb59cfd00c7f1dab6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88de62e36b0b0ecb043b7fac8dc2caee5af5326871e98deb59cfd00c7f1dab6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "082583a19ee0382611178e80a852fe3ef777bd21293422d7532f941de62d9585"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "543bcb86062de9774555add7cac872d66a168786be198173dc92f8e9018ff9e3"
    sha256 cellar: :any,                 x86_64_linux:  "80e9437a6dfd73f19224562178377fb1c27b9cd1b9129630dc40936135a1ddbd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    ENV["HOME"] = testpath
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    review = (testpath/".crit/review.json").read
    assert_match "looks good", review
    assert_match "hello.md", review
  end
end
