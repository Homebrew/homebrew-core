class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v2.0.9.tar.gz"
  sha256 "393ad4a6ced48c327607653d610ef273843085a17b6e5c8013877abdf31e6945"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "ddc00f0733b1f64ce2f19d85ea8e3e077ea3b6db03d515618846957e1dc04b68"
    sha256 arm64_monterey: "69cc9cfaaaa60550ccf87008fe7e37e0a4c44614b9e54804e4f63b9f5fff9f59"
    sha256 arm64_big_sur:  "c4cbb9d4becf2ab47a93c40d4e7520670f490aa38c9d3b74b7bd1377a251b27e"
    sha256 ventura:        "dffa4b23bbb6b339e02d454a84fa66d2dca374300f1e5ffb73057ba62c54d705"
    sha256 monterey:       "581d20b020b93db2b0f82d1ae6e78ada2caa542f2ccac81c63c5cf61c3e588dd"
    sha256 big_sur:        "20517b9560edf3e14c50fe069009828e1170312be3ed9504573b2ea2a87bccea"
    sha256 x86_64_linux:   "81152634fe381e4060c2c598ffe338a23637589b73a37dd5b2bf6a45a02d3f9e"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"

  def install
    # Prevent fluent-bit to install files into global init system
    #
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(IS_DIRECTORY /lib/systemd/system)", "if(False)"
    inreplace "src/CMakeLists.txt", "elseif(IS_DIRECTORY /usr/share/upstart)", "elif(False)"

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end
