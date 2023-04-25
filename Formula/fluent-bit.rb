class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v2.1.1.tar.gz"
  sha256 "0d9fabe9385bec7eb9744157907b5ff44e1a064ea48ec12ade1008bf5873e138"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "f0ecc727d634d4b73415bf0ef4bab58a4b110961e8afab354f718fb93ca3038c"
    sha256 arm64_monterey: "00b5186d46dedc558fc6d5fa68de66ea507bd41ad6daf7685ae8e77d9a676861"
    sha256 arm64_big_sur:  "566a7fa2f1c8b956d4d94abf5396e8884e1672ac925958f0251c2ec125988edb"
    sha256 ventura:        "a6fa690319ebd075c9f6ea99de7dc7b4a52ab4c8bbecfa4487409f350ad4a5aa"
    sha256 monterey:       "fb9e803dba6051ef44897525ddb877ae60ccd1e5eca4a371d03c55e774dc4d70"
    sha256 big_sur:        "f9c971e42c71376eb7664f77ee924f0c19ddfc53d9344ca94ec964e656b66be6"
    sha256 x86_64_linux:   "a9393ff06375283ba85777e9c7f2798fbd66389f4ceeacd3ec743a25d48ee25c"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"
  depends_on "openssl@3"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https://github.com/fluent/fluent-bit/issues/3393
    inreplace "src/CMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY /lib/systemd/system)", "if(False)"
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
