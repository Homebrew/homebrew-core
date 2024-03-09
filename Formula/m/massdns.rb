class Massdns < Formula
  desc "High-performance DNS stub resolver"
  homepage "https://github.com/blechschmidt/massdns"
  url "https://github.com/blechschmidt/massdns/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "93b14431496b358ee9f3a5b71bd9618fe4ff1af8c420267392164f7b2d949559"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d5007ed4f09ff2752ea729daa4010cabe43cca508e672cfc6dfe0b45c63ba13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36501029e41fca6b8b0d302a3e3be12d798f19d7b20cf245ae0a3d0906bcd7b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35a82870db0e5f349bacf0d2ef2f596901c75e42ef40db916c7bd37471d8caa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a07f6b26f6625d833864cbfcfea075eace6957ac9a01d99fbb85874f95e995f"
    sha256 cellar: :any_skip_relocation, sonoma:         "072bb544f1d14c989ff8b15a5dd9506b3fd6eee508f63f7e74f861a13976c061"
    sha256 cellar: :any_skip_relocation, ventura:        "7be8f4b34e6a0194f50f97146ad80d503eca4ae6fda5d90343a977d24580ccd6"
    sha256 cellar: :any_skip_relocation, monterey:       "7365e79331e01ee782e86a393532f2e4a2c3c61b0ddd52dc663b1085814e1435"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cf600e96f9f6e9e693b17894f59e8a14f5cddb2d9690719bbd8553b39b81a0b"
    sha256 cellar: :any_skip_relocation, catalina:       "d24888b27f7a3d0cc3d235e62094d985c378adad90b57939bccf96a14823803c"
    sha256 cellar: :any_skip_relocation, mojave:         "82647b382b8f2c95e7e2186bdc5e85466377c98f09c4320bb6722031114ff7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26c1c368ecea9de403a35522764bd47c5f7d5e0560aec3cdea56c4e8cd059c63"
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
