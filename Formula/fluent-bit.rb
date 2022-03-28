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
    sha256 cellar: :any,                 arm64_monterey: "023c5cf74f7178402544c55ff164168769611dd764d19b1ca218b370625297c0"
    sha256 cellar: :any,                 arm64_big_sur:  "e02250c2fec91daf85b2aea46ff3083f273de8bb253cb7a998c20c8680773a6d"
    sha256 cellar: :any,                 monterey:       "cbd4b1851faeb1d25f4538a3ec5b3e6add4f6163c0c3307e3de452b08a46e082"
    sha256 cellar: :any,                 big_sur:        "96eb4a1ee33b86d388df6d860f8a4d8a30a95085040d8d6d17e5b21dee94e203"
    sha256 cellar: :any,                 catalina:       "9e9a9a6fca7e14a511f6e88641dc9935df12f43a19a0a5302bebaa6d464d72a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9ee623ac914ef92e13f6f1cd094e0d8ed6a7f5a6aaf0def114e637bbf359f3d"
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
