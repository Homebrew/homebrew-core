class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.9.9.tar.gz"
  sha256 "d58dc649f6b4e2433711666ae68c8f443c0542801eb6241b21d245fb421daced"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_monterey: "6b1d8fa9e6131ff905e586d61cde785f2235a595ddb757beb5c1c057b7887e86"
    sha256                               arm64_big_sur:  "5ecae38118a6b3c3e31b05978096547b42dc0793dd791a2ec08de9277037daac"
    sha256                               monterey:       "c0f4ad0f4199a16881a1977fe45acc69ef2b671e14ec235d2d1e0b8ad499624d"
    sha256                               big_sur:        "cb753afabde59ad8e27c8e52c1433b54e9f669569541771f80202cf54ffeb874"
    sha256                               catalina:       "4a955ea629528372fa83f5bf0dd21e472d2cae6340e896b51ff8d9cb1761a481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ebf823556495e710888e335f228342d67b5ae044bd1e471d5dbef15e635af1c"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "libyaml"

  on_linux do
    depends_on "openssl@3"
  end

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
