class Ad < Formula
  desc "Adaptable text editor inspired by vi, kakoune, and acme"
  homepage "https://github.com/sminez/ad"
  url "https://github.com/sminez/ad/archive/refs/tags/0.3.1.tar.gz"
  sha256 "809cd09550daf38b1c4b7d19b975e6dbeb85f424f8942f20fc9cd7808c1ef196"
  license "MIT"
  head "https://github.com/sminez/ad.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54265079d292ffdf2718c837a8479f03851b66909b09981170fb440c17a04baf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4874d80cf8ec7d9a713ac0403e759fb024deea5a0aa9b0baaf77bb75da6dc379"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed349050f01a8877ff816ab5a680f2bdfdce30c022a78f7b2a68ec2a87f4665d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b292412f05f615a3d450d6a45359307330b4b492f822b19c888bab607a191d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "811782a9dfec54873725b526d03d7820f0c07b7ea4c3559cc298a63b7b68ea41"
    sha256 cellar: :any_skip_relocation, ventura:       "42174e0d98492a910e6109919c4217b8653f2e3b43917dc18e79fcf379ba1ee8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2439ba1faa2c4bf0b81716297b78e50dc87e9dfaad2bf35166c9fec01324a5c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69c603b8ed8f547bbf1bbefe0001e8c828de418ee9f1e0e74e19161581b7767f"
  end

  depends_on "rust" => :build

  conflicts_with "netatalk", because: "both install `ad` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man.install buildpath/"docs/man/ad.1"
  end

  test do
    # ad is a gui application
    assert_match "ad v#{version}", shell_output("#{bin}/ad --version").strip

    # test scripts
    (testpath/"test.txt").write <<~TXT
      Hello, World!
      Goodbye, World!
      hello, John!
      Hi, Alex!
    TXT

    (testpath/"hello.ad").write <<~AD
      ,
      x/[Hh]ello, (.*)!/
      p/$1\n/
    AD

    assert_match "World\nJohn\n", shell_output("#{bin}/ad -f #{testpath}/hello.ad #{testpath}/test.txt")
  end
end
