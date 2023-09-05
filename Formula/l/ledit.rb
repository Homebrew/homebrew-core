class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "https://pauillac.inria.fr/~ddr/ledit/"
  url "https://github.com/chetmurthy/ledit/archive/ledit-2-05.tar.gz"
  version "2.05"
  sha256 "493ee6eae47cc92f1bee5f3c04a2f7aaa0812e4bdf17e03b32776ab51421392c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^ledit[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub("-", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4e5f04c79d703b1e22f1b49794bbf416135f209fcad88ae3bc043bc17114c1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "642349a8d05b4f9048fcd7d9fdf389e35d98b921e3d52bd06eee365b50a4f1e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "06141836398681d2250bf04d1bba965038f5f707482f0ecab1cc464c8a95bcfb"
    sha256 cellar: :any_skip_relocation, ventura:        "2f70d37553e6bb5b2e1953781022747f4f1d0659934ef5103e92baa10b481d70"
    sha256 cellar: :any_skip_relocation, monterey:       "da6338af250d9b52557f52707b0730c379bdd8216c53e10477c351f72d6aa406"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d404ace597c8a7062fbe96e15e9e7d1226ec5ca97e0c8981062c77fef10b4eb"
    sha256 cellar: :any_skip_relocation, catalina:       "158141ebf4edc253de428b8789d77eae0b19fdd4d8002e9910cf4c2486a12bb6"
    sha256 cellar: :any_skip_relocation, mojave:         "463dd47cebd8510a630e39008b001e52659f64f1bcda7503bdc8a0f28e55adfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec38d1627d6277d03b8a607a91d6d1d7c43b8f4287b15393e0a26cac27d04e06"
  end

  depends_on "camlp5"
  depends_on "ocaml"

  def install
    # like camlp5, this build fails if the jobs are parallelized
    ENV.deparallelize
    args = %W[BINDIR=#{bin} LIBDIR=#{lib} MANDIR=#{man}]
    system "make", *args
    system "make", "install", *args
  end

  test do
    history = testpath/"history"
    pipe_output("#{bin}/ledit -x -h #{history} bash", "exit\n", 0)
    assert_predicate history, :exist?
    assert_equal "exit\n", history.read
  end
end
