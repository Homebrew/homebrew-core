class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.28.0.tar.gz"
  sha256 "91a85f35e8d7bdffbca44dcc035cde33c8be8b4965ff869cfd810cc0f17b64e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d3697d200bde72af6a7ca8604f747eb35b7b058ad048c4c33fab6dbbb5110e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62acc6cc30b5c4c9ad784bcfd6e9abfb532a1db65e1d982717dc1cc2a27d80d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d39ed9dfcd003a7236379035965d125fcb1411b6f9fd755a4b2fc2cb002cfe6"
    sha256 cellar: :any_skip_relocation, sonoma:        "82a371ffbfc2422b11c75786098549863ace0924d715f1b36f35198225d3e97e"
    sha256 cellar: :any_skip_relocation, ventura:       "7697e9f5ef7ca2ef4cd85ac1551ae1dcffdfc4a6e119b41abe05547dc2466b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84a0ca39650e945fc6514e5668d20c896de41ee3036d76b4fdc7086abba8d6dd"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21" => :build

  uses_from_macos "zlib"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    job_name = "#{OS.mac? ? "mac" : "linux"}Executable#{arch.capitalize}"

    system "gradle", "--no-daemon", "-DreleaseBuild=true", job_name
    bin.install "pkl-cli/build/executable/pkl-#{OS.mac? ? "macos" : "linux"}-#{arch}" => "pkl"
  end

  test do
    assert_equal "1", pipe_output("#{bin}/pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}/pkl --version")
  end
end
