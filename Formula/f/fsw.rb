class Fsw < Formula
  desc "File change monitor with multiple backends"
  homepage "https://emcrisostomo.github.io/fsw/"
  url "https://github.com/emcrisostomo/fsw/releases/download/1.3.9/fsw-1.3.9.tar.gz"
  sha256 "9222f76f99ef9841dc937a8f23b529f635ad70b0f004b9dd4afb35c1b0d8f0ff"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "00cd7d239ddaea10afcdb88fa8c03bd40dae89077f35ac47b0ba19289d1477ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b4199afe2dc6978df9a3f0eb12a92921269a9e7ea62f7b2e7d12faa762e75556"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53e0f1d07609b4db4d89a77402804b95f8825b174430eefec54abe3872ee6163"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec4edbdd834dc9e2bcbaef59bf96beb206bab7c9d6e21045f9e1cce5e27254c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4287660412f232421e55db9e2354fa575d06a4e0b56cfa02ceedfe247160ffa9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0713fafa231ce12c9eaa0e98b495402abe6ce46002140c5a6355fdd032ba69a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb64c893d51acdb15ef748d6e57775f78c921512888fccc903daa0074ef364b4"
    sha256 cellar: :any_skip_relocation, ventura:        "495901d41455a46749f54f9df6d1ee95eec0dd22937c42b946018b8909d25669"
    sha256 cellar: :any_skip_relocation, monterey:       "8fffe4aee0a5723d955c4563a03596b24d55efe1f92c7bbef19f66f1856709af"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f9bbefcdf5b7c82abb30844c9680b9d99ab14aaac142372fc9b7e83d287d343"
    sha256 cellar: :any_skip_relocation, catalina:       "749f3025e6383ae635a30302a3c61a191e57fbe88a7c74b3650749de7e9c8dad"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8a48b6b49e24af2105a97f5dd0b8ce189c136ac33cecf354619e7380d89afd48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eda4b9b2f8597f3fab6330e173bcfdfbd77e41fc406f22be2235055d4d555af"
  end

  def install
    ENV.append "CXXFLAGS", "-stdlib=libc++" if OS.mac?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    io = IO.popen("#{bin}/fsw test")
    (testpath/"test").write("foo")
    sleep 2
    rm testpath/"test"
    sleep 2
    (testpath/"test").write("foo")
    sleep 2
    assert_equal File.expand_path("test"), io.gets.strip
  ensure
    Process.kill "INT", io.pid
    Process.wait io.pid
  end
end
