class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.9.7.tar.gz"
  sha256 "8e5d862c1a65bc073f6daec4b3e7cdbb21e04f078e4231a80fa0ca114b33fc4a"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "ea1647bd3e32f2da67cb007d71053f471f8092620400bba078b81bccd30b50e4"
    sha256                               arm64_big_sur:  "5e372dd48283f9594316e81d98e7ab64ff72f8861e75cffb1fc9fb80a5c24174"
    sha256                               monterey:       "6fcf4ef71f0d9829f760475106fc64b5c9d1f8dbe024b49bda2e6072e77688a3"
    sha256                               big_sur:        "1183bce9dde7d775a82dca3ce92411e2be09790edc419009315044af3e37ea41"
    sha256                               catalina:       "9fb0395cfadaaa37f21aacaf31e5f8e7443b340fdc99673da9e644a960608237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "291d36784398933edd4311c45ddbc650747d196271d440bedbd73298ab9c2fe3"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"

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
