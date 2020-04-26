class BatsCore < Formula
  desc "Bash Automated Testing System"
  homepage "https://github.com/bats-core/bats-core"
  url "https://github.com/bats-core/bats-core/archive/v1.2.0.tar.gz"
  sha256 "c74ea5517d9381c044e8e87427de0113be6ad591213d489aeaa28146daf1c723"

  bottle :unneeded

  depends_on "coreutils"

  conflicts_with "bats", :because => "both install `bats` executables"

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"test.sh").write <<~EOS
      @test "addition using bc" {
        result="$(echo 2+2 | bc)"
        [ "$result" -eq 4 ]
      }
    EOS
    assert_match "addition", shell_output("#{bin}/bats test.sh")
  end
end
