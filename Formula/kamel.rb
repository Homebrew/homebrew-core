class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"

  url "https://github.com/apache/camel-k.git",
    :tag      => "0.3.4",
    :revision => "c47fb2c85e89852f0fd111d1662f57917030ced5"
  head "https://github.com/apache/camel-k.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bca7ed6593fd50b219353b033b76195881576d5edce8154241edb3d249f665e" => :catalina
    sha256 "349b58bd34eeb004baca62ee0e56746cb1256979c83f87aceb62882003b902a3" => :mojave
    sha256 "7dc0dd18e8b3fa8ebaf322db37369929909510c65e8b5472a4624ee822771698" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "openjdk" => :build

  def install
    system "make"
    bin.install "kamel"

    prefix.install_metafiles

    output = Utils.safe_popen_read("#{bin}/kamel completion bash")
    (bash_completion/"kamel").write output

    output = Utils.safe_popen_read("#{bin}/kamel completion zsh")
    (zsh_completion/"_kamel").write output
  end

  test do
    run_output = shell_output("#{bin}/kamel 2>&1")
    assert_match "Apache Camel K is a lightweight", run_output

    help_output = shell_output("echo $(#{bin}/kamel help 2>&1)")
    assert_match "Error: cannot get current namespace", help_output.chomp

    context_output = shell_output("#{bin}/kamel context 2>&1")
    assert_match "Configure an Integration Context", context_output

    get_output = shell_output("echo $(#{bin}/kamel get 2>&1)")
    assert_match "Error: cannot get current namespace", get_output

    version_output = shell_output("echo $(#{bin}/kamel version 2>&1)")
    assert_match "Error: cannot get current namespace", version_output

    version_config_output = shell_output("echo $(#{bin}/kamel version --config=\"/\"2>&1)")
    assert_match "Error: cannot get current namespace", version_config_output

    run_output = shell_output("echo $(#{bin}/kamel run 2>&1)")
    assert_match "Error: accepts at least 1 arg, received 0", run_output

    run_none_output = shell_output("echo $(#{bin}/kamel run None.java 2>&1)")
    assert_match "Error: file None.java does not exist", run_none_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get current namespace", reset_output
  end
end
