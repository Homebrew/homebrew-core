class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.9.4.tar.gz"
  sha256 "82581ca093f87fad9ed5045ed69973ed45cb4a3aea67f74868543e722a19dd61"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "d84e697db42b0c1009d151b654a35d5ac17d5c5639d0385008969a9716a4cb80"
    sha256                               arm64_big_sur:  "6fb69ae473814383acfdea4e8e211bd71101fbd58e85e3cd1e2edc01fddfb260"
    sha256                               monterey:       "6d9a92311600e127595859a3d4e631506319ca91f8787f6ec2d1181b3bdb1d73"
    sha256                               big_sur:        "645d9d1037bd5895a708a3e12bb2a1e7c8b5bce2b45494ecaab0c85d6143e9ca"
    sha256                               catalina:       "f83df8bfd421a3b28895deb596b4dd1fef3c69be875a585bf06cf24a117cbce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0dfa4e37609b191ef19a0f3836ed7ec09f889045b7472b6995442e105a652d4"
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
