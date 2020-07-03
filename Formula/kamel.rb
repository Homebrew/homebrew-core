class Kamel < Formula
  desc "Apache Camel K CLI"
  homepage "https://camel.apache.org/"

  url "https://github.com/apache/camel-k.git",
    :tag      => "1.0.1",
    :revision => "21b88a3bfc07ae9fd9ff5f129ce3a22f1dfc5318"
  head "https://github.com/apache/camel-k.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1179ff945ce1b94dfb803c84f2085af89ea7938f79a78c2097941ac8c08dcff" => :catalina
    sha256 "9629e063b3965d77b910b6fea258c357922416331f80cf5b5004b577d69cfa03" => :mojave
    sha256 "e484a3a6241e35dc03a1ff089764ddaa6f405231d4636330d33e078974e3865c" => :high_sierra
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
    assert_match "Error: cannot get command client: could not locate a kubeconfig", help_output.chomp

    get_output = shell_output("echo $(#{bin}/kamel get 2>&1)")
    assert_match "Error: cannot get command client: could not locate a kubeconfig", get_output

    version_output = shell_output("echo $(#{bin}/kamel version 2>&1)")
    assert_match version.to_s, version_output

    run_output = shell_output("echo $(#{bin}/kamel run 2>&1)")
    assert_match "Error: run expects at least 1 argument, received 0", run_output

    run_none_output = shell_output("echo $(#{bin}/kamel run None.java 2>&1)")
    assert_match "Error: cannot read file None.java: open None.java: no such file or directory", run_none_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Error: cannot get command client: could not locate a kubeconfig", reset_output

    rebuild_output = shell_output("echo $(#{bin}/kamel rebuild 2>&1)")
    assert_match "Config not found", rebuild_output

    reset_output = shell_output("echo $(#{bin}/kamel reset 2>&1)")
    assert_match "Config not found", reset_output
  end
end
