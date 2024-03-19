class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/refs/tags/0.31.0.tar.gz"
  sha256 "bbcb8f8c03b5af33fcfcf11a74e9499f20a9043200b8552f78a6e8ba76e04d11"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4ea74bf32d393287c5efac6401072e8241cfce64a97a20d67cfa7e2f0d1a586"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8337934ba90a866085ec8433b86d6802d69c2d0115b45ca55656d0bf5c98c055"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2493eaf0e346a4286b5f5866f0ea63c8098d86638fc455f35969ce7c19988bde"
    sha256 cellar: :any_skip_relocation, sonoma:         "35925232054def92408d9f694490005b63673865528d256ebe73e260da9e0207"
    sha256 cellar: :any_skip_relocation, ventura:        "bd40f7fc5214eff940489cf72bda5c1c6ed9db239d7d2b24afa7f3d6e83860f7"
    sha256 cellar: :any_skip_relocation, monterey:       "9a29d2a407e7dcfcbf4396faae79317eb484f24ebe44eea8f91bf26c0a490a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "555b5f5813ffb3b901f431d85b17a398ccd6d72e0b06bb2ceff50b6cbbfd4421"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  conflicts_with "cmark-gfm", because: "both install a `cmark.h` header"

  def install
    system "cmake", "-S", ".", "-B", "build",
                        "-DCMAKE_INSTALL_LIBDIR=lib",
                        *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = pipe_output("#{bin}/cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end
