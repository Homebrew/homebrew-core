class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v2.0.2.tar.gz"
  sha256 "d04096118f93a68348ea09749c71709b1a7f68817bdfa4a31aa82656998623d1"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "1a602593700cf72008528ab36f8376921d0ed8d633d6a771410021b3a590f695"
    sha256 arm64_big_sur:  "669955d7b16dad799ce65e842af413cee2a0ea1ae25432613ff3bec819f802f6"
    sha256 monterey:       "4da205a7a045f0eb796785fe1369aad261bf805d8b78ebf717cd02042c660d53"
    sha256 big_sur:        "853e9abb6d042dbc1a9d0052518a18cac307e608a35fd6f9ce88917d1dff71fe"
    sha256 catalina:       "eb73e34a297c28215f53312cf0356f181b485d26094227f1cddab02888b8abb5"
    sha256 x86_64_linux:   "dd575a0f75ba3a63f94bda3f8cf3854f878c1fd95a38298f9c4603b08f28e3f3"
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
