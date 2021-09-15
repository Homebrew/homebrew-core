class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.0.4.tar.gz"
  sha256 "2d9f01e42f2182d008041e145c047a7ca45d31214a2d20b1acf4a148659b5815"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2228e508d26dbb872419ff77bc55ad8a7beaef6fb75710c3ae6bd9ccce4f0cff"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee734d6d87cb992c1a07f256d643ee4c71200334dd05b3e4cd23af23de3e45e8"
    sha256 cellar: :any_skip_relocation, catalina:      "d550046167fad3bcc852ef6dcef502a96c798f67f7bea354227a473b2f761730"
    sha256 cellar: :any_skip_relocation, mojave:        "11147d6c4414285352eb73ff8ffe915e1381e896e8d659c64fede154de55ba45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78275db9ac0ce8b85f19f8293cbb0766e37e6e0c709b291237cf5dd6136d6afa"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  # Support go 1.17, remove after next release
  patch do
    url "https://github.com/projectdiscovery/naabu/commit/944874d7c5cf442fb68c5ad19ed5bf954b313386.patch?full_index=1"
    sha256 "028e8dd2f9bd9634fc05ebcd0381d11320f94a6b9c68bd4a5648640a41089ea1"
  end

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
