class GreenOrb < Formula
  desc "'Observe and Report Buddy' for your SRE toolbox"
  homepage "https://github.com/atgreen/green-orb"
  url "https://github.com/atgreen/green-orb/archive/refs/tags/v0.2.8.tar.gz"
  sha256 "ec4c4424627fdfeb451eed6c84aa0a86a1b74acc99a036c6f4d595cb16351172"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build"
    bin.install "orb"
  end

  test do

    (testpath/"test.yaml").write <<~EOF
      channels:

        - name: "test"
          type: "exec"
          shell: "touch SPLIT"

      signals:

        - regex: "B.*A"
          channel : "test"
    EOF

    system "orb", "-c", testpath/"test.yaml", "echo", "BANANA"

    test_files = testpath.glob("SPLIT")
    assert_equal 1, test_files.length, "Expected exactly one SPLIT file"

  end
end
