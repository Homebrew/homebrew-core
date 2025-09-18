class Clog < Formula
  desc "Colorized pattern-matching log tail utility"
  homepage "https://gothenburgbitfactory.org/clog/docs/"
  url "https://github.com/GothenburgBitFactory/clog/releases/download/v1.3.0/clog-1.3.0.tar.gz"
  sha256 "fed44a8d398790ab0cf426c1b006e7246e20f3fcd56c0ec4132d24b05d5d2018"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/clog.git", branch: "master"

  livecheck do
    url "https://gothenburgbitfactory.org"
    regex(/href=.*?clog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c14c0f289d7f795ec4a4cf88ded115bbd95cbe14d1d2da796fc8e2cfd7b63090"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "324768db7056ee6258ee9bc6a19b15e325061e637a4074201e299f110979f81b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca002e0ad80711f5ca0edc944efd4ab5c0eb5698eecce8913f53e961d7040a90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9bb8aee30f0a25183545a2a3e775fac4f8605aad93e63cb0928c8d196f3812a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "503a96204475c67ba2d564cc98b0964bbff48da89e4c2b3f0d4125a7fb32ffc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce662c5bd6dfdc6dca64911cbdc37ebcfe5aac7eaea48215f94d3b94bba0b37c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b62659f2528522acc8a52ac736dfc66a49b97fb8cc07afa46f5b3cf2bd357d11"
    sha256 cellar: :any_skip_relocation, ventura:        "4c5b54b76cf6efd8d72d07b3dfa526605c1a69c93109155a9fd2d1e985e71455"
    sha256 cellar: :any_skip_relocation, monterey:       "71bcca7b6cb4bf84c6c0c678d45b593f551e9b351bcb0fd557e7e7c0b90648c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "864d26fdc6960a6b4daf9ca76ef52e5e2db4a8ece187dbc7d8b87939e4823d32"
    sha256 cellar: :any_skip_relocation, catalina:       "0a5985eee7c41d2199e64105cb0d32b8e065b57257841f48b2eb36a3a662bc7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1d94d1596bb077ec7890f1bee8650ecf592c75c9415e310eb55f541df1d52c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74b571a8740f2d0d8798ed8ee046d9239404ec6789987b98eb48b25c122c00e3"
  end

  depends_on "cmake" => :build

  def install
    # Workaround for CMake 4 compatibility
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      Next step is to create a .clogrc file in your home directory. See 'man clog'
      for details and a sample file.
    EOS
  end

  test do
    # Create a rule to suppress any line containing the word 'ignore'
    (testpath/".clogrc").write "default rule /ignore/       --> suppress"

    # Test to ensure that a line that does not match the above rule is not suppressed
    assert_equal "do not suppress", pipe_output("#{bin}/clog --file #{testpath}/.clogrc", "do not suppress").chomp

    # Test to ensure that a line that matches the above rule is suppressed
    assert_empty pipe_output("#{bin}/clog --file #{testpath}/.clogrc", "ignore this line").chomp
  end
end
