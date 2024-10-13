class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "https://eradman.com/entrproject/"
  url "https://eradman.com/entrproject/code/entr-5.6.tar.gz"
  sha256 "0222b8df928d3b5a3b5194d63e7de098533e04190d9d9a154b926c6c1f9dd14e"
  license "ISC"
  head "https://github.com/eradman/entr.git", branch: "master"

  livecheck do
    url "https://eradman.com/entrproject/code/"
    regex(/href=.*?entr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d802f80cb83d3fe1cd1acb2b8e0083afa683cbe2f584a82394eb962e11608440"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d878b113e680a4cbab1f35939b63ec51fb8fedf06ae7dc8662610077184cf622"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6e970b963f6409076ea40fd51487b354edaf83febd21ad4849989abd4399eaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb0d171f6dbe8fe018b51605dd51e32f63ae9da0cbabba079fbaf3a011bc6207"
    sha256 cellar: :any_skip_relocation, sonoma:         "061556e2b532a2c5d142faf24886377d216bb05757639d4356dab486180891d5"
    sha256 cellar: :any_skip_relocation, ventura:        "7c640c28c176df49179ac2ab3c1de08c1d194bc49dee50b0b4b905231fb956ed"
    sha256 cellar: :any_skip_relocation, monterey:       "79e1e4af44349c50e37777a6ba3c3ef9bce47e5488fab2f103d0108cc662b045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26cba6bdd62572059e3f2b4422b9960fe412d7012491fcbad13803c7a8dfbe89"
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end

    assert_equal "New File", pipe_output("#{bin}/entr -n -p -d echo 'New File'", testpath.to_s).strip
  end
end
