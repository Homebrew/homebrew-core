class Goshs < Formula
  desc "Simple, yet feature-rich web server written in Go"
  homepage "https://goshs.de"
  url "https://github.com/goshs-labs/goshs/archive/refs/tags/v2.1.8.tar.gz"
  sha256 "3d1e4ab15d7b6f5fba7d1e793fbb803dc085f6cc66d3c39d9f8a818ae4d55346"
  license "MIT"
  head "https://github.com/goshs-labs/goshs.git", branch: "main"

  bottle do
    manifest_sha256 "ffcaea35c144be61fcc35dac7fd5b862d57fe10575680019ca9d16634e2cbcb2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "79d08ae0a76800adb75976a42f4ea1e039ac3347435d2868d2df97efc5ca96bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "79d08ae0a76800adb75976a42f4ea1e039ac3347435d2868d2df97efc5ca96bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79d08ae0a76800adb75976a42f4ea1e039ac3347435d2868d2df97efc5ca96bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9f9fff5ca43e0ef91d5935228759f3a7b081557eb527d31b4b0eb21efdb60236"
    sha256 cellar: :any,                 x86_64_linux:      "59da492f1fd8d037d4e5761cbe332066238c0c22469b1b9942528ab03256f841"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goshs -v")

    (testpath/"test.txt").write "Hello, Goshs!"

    port = free_port
    with_test_process(bin/"goshs", "-p", port.to_s, "-d", testpath, "-si") do
      output = shell_output("curl --retry 5 --retry-connrefused -s http://localhost:#{port}/test.txt")
      assert_match "Hello, Goshs!", output
    end
  end
end
