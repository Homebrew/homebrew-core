class Massdns < Formula
  desc "High-performance DNS stub resolver"
  homepage "https://github.com/blechschmidt/massdns"
  url "https://github.com/blechschmidt/massdns/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "93b14431496b358ee9f3a5b71bd9618fe4ff1af8c420267392164f7b2d949559"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4ccc67bf2a881c34a2cd1ab5fab97cb109e9cdf1ac60eb6861ae8cea2f02b31d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a9a5d00f32970e270e6d1ab85b7ec437efdd1b74e1e4b40f6d938f74f74ee7f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7c9496b840fee8c62fdde8b1799a12e957ccf055a938d34c115c4a1791c9aac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e9ffbddb8c8d7f7d2d6ce7c65a144b01c038332feee271f1168b8d2885876db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74cbadfee753d69341fde43f09661512be522ccfaa8c146f1c1feb08ecb181ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "0faf77da9ccb9971a4007ef15e811faaadb03cef023719efce6538a7a4a1e21d"
    sha256 cellar: :any_skip_relocation, ventura:        "d849531a2de18b6f920761dd14353f4bd843814e6dce35a02e526998ae26b17d"
    sha256 cellar: :any_skip_relocation, monterey:       "e91304ed064fb3001ab55bb5a61bc7830c29681583c00d001e943911e9789b75"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1b8fc5d3cb53ae0d3f3b7e94757c3ec2cf458fec82695bda03aee3f7461f006c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "191060c2099a28427517a56d63ba4ca14c410870a44ec6a2621fbdb2394853f4"
  end

  depends_on "cmake" => :build

  uses_from_macos "libpcap"

  # upstream patch PR, https://github.com/blechschmidt/massdns/pull/148
  patch do
    url "https://github.com/blechschmidt/massdns/commit/a96b5d213a5643fbe3de1ba6e401e359673f0a21.patch?full_index=1"
    sha256 "10a07d6f8241500cdc6320fe1dc5461b9573ce8d70fbf96b62855192a3829e1b"
  end
  patch do
    url "https://github.com/blechschmidt/massdns/commit/66d30af33d36109d244a92a69691c5deba13fd28.patch?full_index=1"
    sha256 "a3070e5522e612ea5f868e705e5667c38b8437969e2690f8545a247a7a2ee970"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    etc.install Dir["lists", "scripts"]
  end

  test do
    cp_r etc/"lists/resolvers.txt", testpath
    (testpath/"domains.txt").write "docs.brew.sh"
    system bin/"massdns", "-r", testpath/"resolvers.txt", "-t", "AAAA", "-w", "results.txt", testpath/"domains.txt"

    assert_match ";; ->>HEADER<<- opcode: QUERY, status: NOERROR, id:", File.read("results.txt")
    assert_match "IN CNAME homebrew.github.io.", File.read("results.txt")
  end
end
