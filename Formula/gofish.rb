class Gofish < Formula
  desc "Cross-platform systems package manager"
  homepage "https://gofi.sh"
  url "https://github.com/fishworks/gofish.git",
      tag:      "v0.15.0",
      revision: "691768d1a77f2adb3e57271cddf6fea31cc6dadf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "945720778ed876253c3c8f11ded7a7e00cc5f67f053b5a58a0bad9c441e0de13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6f1b84bfba814847440e1b0e4e91b6cc884a7326a97e992ec9e31d198894e5a"
    sha256 cellar: :any_skip_relocation, monterey:       "52a8ba4df8e73f678998ce22aae82547a1f376dc72cbccb6f8f8c95fc0ae4a6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb495999ef2e9e147d6f852992aa18643c1d2eb5372ddf5db9fed4ca2b870acd"
    sha256 cellar: :any_skip_relocation, catalina:       "8d0f1db0582aad9e2759ca39e1cb472dc6d819a915601cef48f6cc87ad7ba6ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "181a39788ace1382d777946a38893160482dd514a05d576c167a2f5c73630b02"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "bin/gofish"
  end

  def caveats
    <<~EOS
      To activate gofish, run:
        gofish init
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/gofish version")
  end
end
