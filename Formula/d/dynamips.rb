class Dynamips < Formula
  desc "Cisco 7200/3600/3725/3745/2600/1700 Router Emulator"
  homepage "https://github.com/GNS3/dynamips"
  url "https://github.com/GNS3/dynamips/archive/refs/tags/v0.2.23.tar.gz"
  sha256 "503bbb52c03f91900ea8dbe8bd0b804b76e2e28d0b7242624e0d3c52dda441a1"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "aad0f86002ca962368935cb17bd171e427569af71ba29399d6b7f079b23a0be4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4bc0583f71947ce92c88e24ad659542886af0698ef9601e6432ddb3c925c208e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3db4b7a6d2140635eae5d91a96810fbbef58144dcad5f7ed77743f930df696d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "106e42f80c14fe08866951b8e1d5032f98fe3d8a57c497856d09aa0657a7120b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea736c8b0b31f481066a64f07a154e5bd8b556be4cd259c1a0e0d8da509da3be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e685176d9affeeacddcf08b39f639a998c0dde4027ad6131d43bf013b99cefc6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6be2e4c5d8e2aa875a346df429bd6b513d5c0c8d49f84c4fe29615226fb75d71"
    sha256 cellar: :any_skip_relocation, ventura:        "df2f66c85bba8ebe55a40adca313d3007fd78a11e31101cbf56095c261ba419a"
    sha256 cellar: :any_skip_relocation, monterey:       "34cd5717a4449d9d69c7741ccf492a010c8b6fcaae137b3e84869ed0426b0be3"
    sha256 cellar: :any_skip_relocation, big_sur:        "537b49bfac716211677ac7da74d5c78d111da724c80b3811976f281eb57237f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0a799bf4755db29172a339280a49b3e560c0762090c4b53e06b68fb24e169800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43b17aecf4adaa4164f12a3ce012cb288a812d75e2f28cf55b48d87c8b000dc2"
  end

  depends_on "cmake" => :build

  uses_from_macos "libpcap"

  on_macos do
    # https://github.com/GNS3/dynamips/issues/142
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
  end

  def install
    cmake_args = ["-DANY_COMPILER=1"]
    cmake_args << if OS.mac?
      "-DLIBELF_INCLUDE_DIRS=#{Formula["libelf"].opt_include}/libelf"
    else
      "-DLIBELF_INCLUDE_DIRS=#{Formula["elfutils"].opt_include}"
    end

    # Workaround to build with CMake 4
    cmake_args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    odie "Remove CMake workaround!" if version > "0.2.23"

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dynamips", "-e"
  end
end
