class Mx < Formula
  desc "Command-line tool used for the development of Graal projects"
  homepage "https://github.com/graalvm/mx"
  url "https://github.com/graalvm/mx/archive/refs/tags/5.296.0.tar.gz"
  sha256 "d6867cdfa80575c70a3e64ada62e8cb22a226e2df6dc4c4bf6db5964bd9a8fde"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "89837ac3444a291c6ffb8cf795941146d5e3c0c2b0555eefe37e56781331105d"
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
    ENV["JAVA_HOME"] = Language::Java.java_home

    testpath.install resource("testdata")
    cd "vm" do
      output = shell_output("#{bin}/mx suites")
      assert_match "distributions:", output
    end
  end
end
