class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.9.1.tar.gz"
  sha256 "b0c06f8cc7e5571d9768efe56e59d9aa7efec04c797fd18a3268406973a5b72d"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "51c49e9cc32fd5b5cba72aefd9dd0e54b7870389b99d070f54dd75b9d227b762"
    sha256 cellar: :any,                 arm64_big_sur:  "a7b12d28c913b9ec1949b9594d3bbb597f3fb8eafafd2d60e68ed1ff99450491"
    sha256 cellar: :any,                 monterey:       "c1fd41431a8c90c87e6db3078f6ee01f4aa0a5d2b2de979b8fbdc6ea4b93e5e1"
    sha256 cellar: :any,                 big_sur:        "dac7be8327a8c77a0bd6744c3676bc2bb867b933e3010280e283bdd1b9ae813e"
    sha256 cellar: :any,                 catalina:       "3effc4d9841b8f6a52dda7696e06451eb5704d6211df865c19b9f6af20f39513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bc6aace9c05af707259422e260dcc58dea64b8fe8b51aaf0e7125d0459576ed"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    # Prevent fluent-bit to install files into global init system
    #
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    chdir "build" do
      # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
      # is not set then it's forced to 10.4, which breaks compile on Mojave.
      # fluent-bit builds against a vendored Luajit.
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
