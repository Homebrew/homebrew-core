class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "https://gosu-lang.github.io/"
  url "https://github.com/gosu-lang/gosu-lang/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "fb2b3ed33975c28fd6327fd9d3ed6619623c31f0f6079fcd739db2125f58ff49"
  license "Apache-2.0"
  head "https://github.com/gosu-lang/gosu-lang.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c964f7a4e3b0d767e3af1cb329ee0ba9fb9b356aa962c919225f66689b857c1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a45d1461660e03928e441c11b2e2a307edf54d097d26d86894c56012810b5701"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d0bf0c60b1b332d9a160b9f68718b30013982481a3160757b431aba48978db4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d50854e07f4379b9f2a0e9dedadfc01cbf0ac84dbcfefb5cc313b36f1a808222"
    sha256 cellar: :any_skip_relocation, ventura:       "a70ac41afd91682bca1ddaab2d55ec2d9d407b726551b893e00b594e049a0bd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d0f54839f60744a43b1d4942583ad9f6797644dd596e87cc07e1ec43e5b665b"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  skip_clean "libexec/ext"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("11")

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    (bin/"gosu").write_env_script libexec/"bin/gosu", Language::Java.java_home_env("11")
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end
