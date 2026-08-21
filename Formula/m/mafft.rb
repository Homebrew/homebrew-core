class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://gitlab.com/sysimm/mafft.git",
      tag:      "v7.526",
      revision: "ee9799916df6a5d5103d46d54933f8eb6d28e244"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/The latest version is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "fc5c7bda0836109bd4bafa219c61bb3025b5bcc7e0c754cdd69806fca7d79081"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "435f07a25b111e3acb645fdb613854e7872c0fa7cb0134a084efcd45f5df5099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6bc4e37e3c7e5ee2d37791927eb80e1ab0704029765cfad46d604cd093ab4fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad09be10bf7387c18b0ed95d7a3f5a497902299744ef101914e87e4b651cb155"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf69c5b35b4a713690785897d4543e0bb7e5c92ff580c8e005ae6d258bf1d082"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2bb12ef558ba26f6f8a4a7c99d9242249cd90131049fb142f33dd3498a48dff"
    sha256 cellar: :any_skip_relocation, ventura:        "6a8c4efa40ecb9439d1ea9dbcfdccca5ebbfb956d628804e8ec72247c1eec97d"
    sha256 cellar: :any_skip_relocation, monterey:       "ef1474d6acd018dbabf4d0ba62fbed486c678fe3dcf75df62d8b8a25580895d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "90835e351fa993cae4c7be392839d812ec10c8186ab29833e600322b9ef2cd51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee6f5f787b6cb179ae7c08d31b8b3f8be1f0ace537c2c9747bb2645f99df37a5"
  end

  def install
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} PREFIX=#{prefix} install]
    system "make", "-C", "core", *make_args
    system "make", "-C", "extensions", *make_args
  end

  test do
    (testpath/"test.fa").write ">1\nA\n>2\nA"
    output = shell_output("#{bin}/mafft test.fa")
    assert_match ">1\na\n>2\na", output
  end
end
