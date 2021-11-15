class Demumble < Formula
  desc "More powerful symbol demangler (a la c++filt)"
  homepage "https://github.com/nico/demumble"
  url "https://github.com/nico/demumble/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "663e5d205c83cc36a257bb168d3ecbc2a49693088c0451b2405d25646651c63e"
  license "Apache-2.0"
  head "https://github.com/nico/demumble.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff3563d728d6ad3ba851fe1a9e95e599f0fb835ea6e046b30e329537f19aaedc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b43c1b4396d845e300f9f5c7746fb6a393ea8a3189c822ba96c35cb1ddd7786b"
    sha256 cellar: :any_skip_relocation, monterey:       "3677ec9a895d02cd6694710152625d98f903720e891774d292a5ea454d11bbc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7dc50c58c1188bd07b90c0ecb57031f24ad3b463f41befd78ea5b5cfd1577e0"
    sha256 cellar: :any_skip_relocation, catalina:       "c79b46404de20da59fb13b225006147666199f6a03b56e43820d20ae818dafff"
    sha256 cellar: :any_skip_relocation, mojave:         "f843e7116cf05d2a7dff4fb8351d0609e8120d49aad84e810f44cc85d6b62811"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    # CMakeLists.txt does not contain install rules
    bin.install "build/demumble"
  end

  test do
    mangled = "__imp_?FLAGS_logtostderr@fLB@@3_NA"
    demangled = "__imp_bool fLB::FLAGS_logtostderr"
    assert_equal demangled, pipe_output(bin/"demumble", mangled)
  end
end
