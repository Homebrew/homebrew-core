class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://github.com/graalvm/mx/archive/refs/tags/5.292.6.tar.gz"
  sha256 "92894dacb210c8f12701a16b275bfbd42390213520deb68bed045f40e3a87164"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "dd671091cb445364e11ea8765b21cebfecb0d4f587520ebfdabae5fada44827a"
    sha256 cellar: :any_skip_relocation, catalina: "36514ea834b5d34abd5f0a0f180aff3284b833449fed7bdea731c62e2dbde712"
    sha256 cellar: :any_skip_relocation, mojave:   "a58e3e75ce71e9e813c9074cf2db80a9a57385668b239d88747f338b54a1d5d4"
  end

  depends_on "openjdk" => :test
  depends_on arch: :x86_64
  depends_on "python@3.9"

  resource("testdata") do
    url "https://github.com/oracle/graal/archive/refs/tags/vm-21.0.0.2.tar.gz"
    sha256 "fcb144de48bb280f7d7f6013611509676d9af4bff6607fe7aa73495f16b339b7"
  end

  def install
    libexec.install Dir["*"]
    (bin/"mx").write_env_script libexec/"mx", MX_PYTHON: "#{Formula["python@3.9"].opt_bin}/python3"
    bash_completion.install libexec/"bash_completion/mx" => "mx"
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_libexec/"openjdk.jdk/Contents/Home"

    testpath.install resource("testdata")
    cd "vm" do
      output = shell_output("#{bin}/mx suites")
      assert_match "distributions:", output
    end
  end
end
